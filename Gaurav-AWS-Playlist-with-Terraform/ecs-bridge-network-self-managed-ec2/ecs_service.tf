resource "aws_ecs_service" "nginx" {
  name            = "nginx-bridge-svc"
  cluster         = data.terraform_remote_state.stack1.outputs.cluster_name
  task_definition = aws_ecs_task_definition.nginx_bridge.arn
  desired_count   = 1
  capacity_provider_strategy {
    capacity_provider = data.terraform_remote_state.stack1.outputs.capacity_provider_name
    weight              = 1
    base                = 0
  }
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}