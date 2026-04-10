resource "aws_launch_template" "ecs_self" {
  name_prefix = "ecs-self-"
  image_id = data.aws_ssm_parameter.ecs_al2023_ami.value
  instance_type = "t3.small"
  key_name = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

  vpc_security_group_ids = [data.aws_security_group.default.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    
    ebs {
        # AL2023 ECS-optimized AMI root snapshot requires >= 30 GiB
        volume_size = 30
        volume_type = "gp3"
        delete_on_termination = true
    }
  } 

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
    EOT
  )
}

resource "aws_autoscaling_group" "ecs_self" {
  name = "ecs-self-asg"
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size = 1
  max_size = 5
  desired_capacity = 1
  health_check_type = "EC2"
  health_check_grace_period = 300

  launch_template {
    id = aws_launch_template.ecs_self.id
    version = "$Latest"
  }

  tag {
    key = "AmazonECSManaged"
    value = ""
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "ecs-self-managed"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "self_ec2" {
  name = "self-managed-ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_self.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status = "ENABLED"
      target_capacity = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10000
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  capacity_providers = [
    aws_ecs_capacity_provider.self_ec2.name,
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.self_ec2.name
    weight = 1
    base = 0
  }
}


