data "terraform_remote_state" "stack2" {
  backend = "local"
  config = {
    path = "../ecs-cluster-managed-instances/terraform.tfstate"
  }
}
data "terraform_remote_state" "stack1" {
  backend = "local"
  config = {
    path = "../ecs-cluster-fargate-self-managed-ec2/terraform.tfstate"
  }
}
