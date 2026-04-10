variable "region" {
  type = string
  default = "ap-south-1"
}

variable "cluster_name" {
  type = string
  default = "ecs-managed-instance-cluster"
}

# Role attached to ecs-instance-profile (from stack 1 / capacity provider). ECS Managed Instances
# runs as ecs-infrastructure-role and must iam:PassRole this role when launching EC2.
variable "ecs_instance_role_name" {
  type        = string
  description = "Name of the IAM role used by the managed capacity provider's instance profile."
  default     = "ecs-instance-role"
}

variable "ecs_instance_profile_name" {
  type        = string
  description = "Instance profile name (PassRole is sometimes evaluated on this ARN)."
  default     = "ecs-instance-profile"
}