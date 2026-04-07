# Cognito user pools in email_sending_account = DEVELOPER need:
# 1) Service-linked role AWSServiceRoleForAmazonCognitoIdpEmailService (one per account; not created here).
# 2) Resource policy on the SES domain identity authorizing email.cognito-idp.amazonaws.com to send.
#
# If `terraform plan` fails because the role does not exist yet (rare greenfield account), create it once:
#   aws iam create-service-linked-role --aws-service-name email.cognito-idp.amazonaws.com
#
# To adopt an existing SLR into state instead (if you still use a managed resource elsewhere), use import on
# aws_iam_service_linked_role — this stack only *reads* the role via data source.
#
# Ref: https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-email.html

data "aws_iam_role" "cognito_email" {
  name = "AWSServiceRoleForAmazonCognitoIdpEmailService"
}

data "aws_iam_policy_document" "ses_allow_cognito_email_service" {
  statement {
    sid    = "AllowCognitoEmailServiceSend"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["email.cognito-idp.amazonaws.com"]
    }

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = [local.ses_source_arn]
  }
}

resource "aws_ses_identity_policy" "cognito" {
  identity = var.root_domain
  name     = "girik-demo-cognito-ses-send"
  policy   = data.aws_iam_policy_document.ses_allow_cognito_email_service.json
}
