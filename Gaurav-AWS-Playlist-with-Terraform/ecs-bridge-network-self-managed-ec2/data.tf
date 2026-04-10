data "terraform_remote_state" "stack1" {
  backend = "local"
  config = {
    path = "../ecs-cluster-fargate-self-managed-ec2/terraform.tfstate"
  }
}