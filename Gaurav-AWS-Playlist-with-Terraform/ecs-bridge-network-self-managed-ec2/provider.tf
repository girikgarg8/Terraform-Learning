provider "aws" {
  region = coalesce(data.terraform_remote_state.stack1.outputs.region, var.region)
}