output "ses_source_arn_used" {
  description = "SES identity ARN passed to Cognito email_configuration (auto or from var.ses_domain_identity_arn)"
  value       = local.ses_source_arn
}

output "cognito_email_service_linked_role_arn" {
  description = "Existing service-linked role Cognito uses for SES (DEVELOPER mode)"
  value       = data.aws_iam_role.cognito_email.arn
}

output "ses_identity_policy_name" {
  description = "SES identity policy attached to var.root_domain for Cognito"
  value       = aws_ses_identity_policy.cognito.name
}

output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "issuer_url" {
  value = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.this.id}"
}

output "hosted_ui_base" {
  description = "Origin for Hosted UI and OAuth endpoints"
  value       = local.hosted_ui_base
}

output "login_url" {
  value = format(
    "%s/oauth2/authorize?client_id=%s&response_type=code&scope=openid+email+profile&redirect_uri=%s",
    local.hosted_ui_base,
    aws_cognito_user_pool_client.app.id,
    urlencode(var.callback_urls[0])
  )
}

output "oauth2_token_url" {
  value = "${local.hosted_ui_base}/oauth2/token"
}

output "client_id" {
  value = aws_cognito_user_pool_client.app.id
}

output "client_secret" {
  value       = aws_cognito_user_pool_client.app.client_secret
  sensitive   = true
  description = "terraform output -raw client_secret"
}

# ---------------------------------------------------------------------------
# Exchange authorization code for tokens (confidential client).
# Run these in your shell (not in this file):
#
#   export BASE="$(terraform output -raw hosted_ui_base)"
#   export CID="$(terraform output -raw client_id)"
#   export SEC="$(terraform output -raw client_secret)"
#   export REDIRECT="$(echo -n 'https://example.com/callback' | jq -sRr @uri)"
#   export CODE="<paste code from redirect>"
#
# curl -sS -X POST "$BASE/oauth2/token" \
#   -H "Content-Type: application/x-www-form-urlencoded" \
#   -u "$CID:$SEC" \
#   --data-urlencode "grant_type=authorization_code" \
#   --data-urlencode "code=$CODE" \
#   --data-urlencode "redirect_uri=https://example.com/callback"
#
# Public client: omit -u; add --data-urlencode "client_id=$CID"
# ---------------------------------------------------------------------------