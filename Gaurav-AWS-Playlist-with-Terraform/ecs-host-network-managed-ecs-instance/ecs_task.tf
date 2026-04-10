resource "aws_ecs_task_definition" "nginx_host" {
  family                   = "nginx-host-stack2"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  cpu                      = "512"
  memory                   = "512"
  execution_role_arn       = data.terraform_remote_state.stack1.outputs.task_execution_role_arn
  container_definitions = jsonencode([{
    name      = "my-nginx-container"
    image     = "coolgourav147/nginx-custom:v1"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}