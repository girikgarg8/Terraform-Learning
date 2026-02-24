resource "aws_iam_user" "sample" {
    name = "sample-user"

    path = "/"

    tags = {
        Name = "sample-user"
    }
}