resource "aws_ses_email_identity" "sender" {
  email = var.sender_email
}

resource "aws_ses_email_identity" "recipient" {
  email = var.recipient_email
}

resource "null_resource" "send_test_email" {
  depends_on = [
    aws_ses_email_identity.sender,
    aws_ses_email_identity.recipient,
  ]
  provisioner "local-exec" {
    command = <<-EOT
      aws ses send-email \
        --region ${data.aws_region.current.id} \
        --from "${var.sender_email}" \
        --destination "ToAddresses=${var.recipient_email}" \
        --message "Subject={Data='SES Test from Terraform',Charset=utf-8},Body={Text={Data='Test email sent via Terraform and AWS SES.',Charset=utf-8}}"
    EOT
  }
}