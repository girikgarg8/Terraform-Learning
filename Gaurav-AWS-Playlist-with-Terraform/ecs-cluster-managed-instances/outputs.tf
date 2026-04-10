output "cluster_name" {
  value = aws_ecs_cluster.managed.name
}
output "infrastructure_role_arn" {
  value = aws_iam_role.ecs_infrastructure.arn
}