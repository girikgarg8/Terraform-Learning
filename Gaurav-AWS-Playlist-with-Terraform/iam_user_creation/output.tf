output "sample_user_password" {
    value = aws_iam_user_login_profile.sample.password
    sensitive = true # run terraform output -raw sample_user_password after terraform apply
    description = "Console password for sample-user (only visible once after apply)"
}