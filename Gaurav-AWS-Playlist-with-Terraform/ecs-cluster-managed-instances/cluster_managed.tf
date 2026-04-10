# hashicorp/aws does not support ManagedInstancesConfiguration on aws_ecs_cluster yet
# (configuration {} only allows execute_command + managed_storage). iam.tf still creates
# ecs-infrastructure-role (policy: AmazonECSInfrastructureRolePolicyForManagedInstances).
#
# Use the AWS Console to turn on ECS Managed Instances and point the cluster at this role.
# Official guide: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/update-cluster-managed-instances.html
#
# Prerequisite: apply this stack first (`terraform apply`). Note outputs `cluster_name` and
# `infrastructure_role_arn`. Use the same AWS Region as var.region (e.g. ap-south-1).
#
# Steps (labels may vary slightly in the console):
#
#   1. Open Amazon ECS: https://console.aws.amazon.com/ecs/v2
#   2. In the top bar, select the Region where the cluster was created.
#   3. Left navigation: Clusters → click the cluster name matching `terraform output -raw cluster_name`.
#   4. Choose Update cluster (or Infrastructure / Cluster configuration → Edit, depending on UI).
#   5. Under capacity / infrastructure for EC2, choose Amazon ECS Managed Instances (not "self-managed"
#      ASG-only, unless that is what you want).
#   6. Infrastructure role: select ecs-infrastructure-role (the role Terraform created). If it does
#      not appear, confirm you are in the correct account and Region; IAM → Roles → verify the role exists.
#   7. Instance profile / launch template / networking: complete the fields the wizard requires for
#      Managed Instances (ECS needs an instance profile for the managed EC2 hosts, subnets, security
#      groups, etc.). Create those in IAM/EC2/VPC first if you do not already have them.
#   8. Save / Update cluster and wait until the cluster finishes updating.
#
# Terraform only creates the infrastructure IAM role; the console flow wires that role (and related
# settings) into the cluster’s Managed Instances configuration.
resource "aws_ecs_cluster" "managed" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}