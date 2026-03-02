# IAM Role for S3 Full Access (Gateway Endpoint Demo)

resource "aws_iam_role" "s3_full_access_role" {
  name = "s3-full-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })

  tags = {
    Name = "S3 Full access role"
  }
}

# Attach S3 Full Access Policy
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role = aws_iam_role.s3_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM Role for EC2 Full Access (Interface Endpoint Demo)

resource "aws_iam_role" "ec2_full_access_role" {
  name = "ec2-full-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })

  tags = {
    Name = "EC2 full access role"
  }
}

# Attach EC2 Full Access policy

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role = aws_iam_role.ec2_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Instance Profile for S3 Demo Instance

resource "aws_iam_instance_profile" "s3_demo_profile" {
  name = "s3-demo-profile"
  role = aws_iam_role.s3_full_access_role.name
}

resource "aws_iam_instance_profile" "ec2_demo_profile" {
  name = "ec2-demo-profile"
  role = aws_iam_role.ec2_full_access_role.name
}
