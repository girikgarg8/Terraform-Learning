data "aws_route53_zone" "main" {
  name         = var.root_domain
  private_zone = false
}

data "aws_caller_identity" "current" {}

locals {
  use_managed = var.domain_mode == "managed"
  use_custom  = var.domain_mode == "custom"

  # Cognito DEVELOPER email mode: default to this account's verified domain identity
  ses_source_arn = trimspace(var.ses_domain_identity_arn) != "" ? trimspace(var.ses_domain_identity_arn) : "arn:aws:ses:${var.aws_region}:${data.aws_caller_identity.current.account_id}:identity/${var.root_domain}"

  hosted_ui_base = local.use_managed ? "https://${aws_cognito_user_pool_domain.managed[0].domain}.auth.${var.aws_region}.amazoncognito.com" : "https://${var.custom_domain_host}"
}

# User pool: email sign-in, password + email OTP, SES

resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  sign_in_policy {
    allowed_first_auth_factors = ["PASSWORD", "EMAIL_OTP"]
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "gender"
    attribute_data_type = "String"
    mutable             = true
    required            = false

    string_attribute_constraints {
      min_length = 1
      max_length = 16
    }
  }

  email_configuration {
    email_sending_account  = "DEVELOPER"
    source_arn             = local.ses_source_arn
    from_email_address     = "admin@${var.root_domain}"
    reply_to_email_address = "noreply@${var.root_domain}"
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  # SES identity policy + Cognito email SLR must already exist (see cognito_email_iam.tf)
  depends_on = [
    data.aws_iam_role.cognito_email,
    aws_ses_identity_policy.cognito,
  ]
}

resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Administrators"
}

resource "aws_cognito_user_group" "customer" {
  name         = "customer"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Customers"
}

resource "aws_cognito_user_pool_client" "app" {
  name         = "girik demo app"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                               = true
  prevent_user_existence_errors                 = "ENABLED"
  enable_token_revocation                       = true
  enable_propagate_additional_user_context_data = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_AUTH",
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = ["COGNITO"]

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user" "demo" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = var.demo_user_email
  password     = var.demo_user_password

  attributes = merge(
    {
      email          = var.demo_user_email
      email_verified = "true"
      name           = var.demo_user_name
    },
    var.demo_user_gender != null ? { "custom:gender" = var.demo_user_gender } : {}
  )

  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_cognito_user_in_group" "demo_admin" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = aws_cognito_user.demo.username
  group_name   = aws_cognito_user_group.admin.name
}

resource "aws_cognito_user_in_group" "demo_customer" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = aws_cognito_user.demo.username
  group_name   = aws_cognito_user_group.customer.name
}

# Managed Hosted UI domain

resource "aws_cognito_user_pool_domain" "managed" {
  count                 = local.use_managed ? 1 : 0
  domain                = var.cognito_domain_prefix
  user_pool_id          = aws_cognito_user_pool.this.id

  lifecycle {
    precondition {
      condition     = length(var.cognito_domain_prefix) > 0
      error_message = "Set cognito_domain_prefix when domain_mode=managed (globally unique prefix)."
    }
  }
}

# --- Custom domain: ACM us-east-1 + validation + Cognito domain + alias ---

resource "aws_acm_certificate" "cognito" {
  count             = local.use_custom ? 1 : 0
  provider          = aws.us_east_1
  domain_name       = var.custom_domain_host
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = length(var.custom_domain_host) > 0
      error_message = "Set custom_domain_host when domain_mode=custom (e.g. cognitodemo.girikgarg.xyz)."
    }
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = local.use_custom ? {
    for dvo in aws_acm_certificate.cognito[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cognito" {
  count                   = local.use_custom ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cognito[0].arn
  validation_record_fqdns = [for r in aws_route53_record.acm_validation : r.fqdn]
}

resource "aws_cognito_user_pool_domain" "custom" {
  count                 = local.use_custom ? 1 : 0
  domain                = var.custom_domain_host
  user_pool_id          = aws_cognito_user_pool.this.id
  certificate_arn       = aws_acm_certificate_validation.cognito[0].certificate_arn
}

resource "aws_route53_record" "cognito_alias" {
  count   = local.use_custom ? 1 : 0
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.custom_domain_host
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.custom[0].cloudfront_distribution
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# Hosted UI CSS requires a domain on the user pool first (managed or custom).
resource "aws_cognito_user_pool_ui_customization" "demo" {
  user_pool_id = aws_cognito_user_pool.this.id
  client_id    = aws_cognito_user_pool_client.app.id

  css = <<-CSS
    .banner-customizable { background-color: #1e3a5f !important; }
    .label-customizable { color: #1e3a5f; font-weight: 600; }
    .submitButton-customizable { background-color: #2d6a4f !important; border-radius: 8px; }
    .textDescription-customizable { color: #333; }
  CSS

  depends_on = [
    aws_cognito_user_pool_domain.managed,
    aws_cognito_user_pool_domain.custom,
  ]
}