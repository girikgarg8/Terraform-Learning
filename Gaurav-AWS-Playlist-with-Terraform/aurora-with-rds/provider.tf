provider "aws" {
  alias = "primary"
  region = "ap-south-1"
}

provider "aws" {
  alias = "replica"
  region = "ap-south-2"
}