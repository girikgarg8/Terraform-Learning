# Provider for ap-south-1 (On-Premises Simulation)
provider "aws" {
  alias  = "on_premises"
  region = var.on_premises_region
}

# Provider for ap-south-2 (AWS Cloud)
provider "aws" {
  alias  = "aws_cloud"
  region = var.aws_cloud_region
}