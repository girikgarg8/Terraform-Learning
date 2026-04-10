variable "region" {
  type    = string
  default = "ap-south-1"
}

# Must match the capacity provider you created in the console for the managed-instances cluster.
variable "managed_capacity_provider_name" {
  type    = string
  default = "managed-capacity-provider"
}

# Used when stack2 remote state has no outputs (e.g. cluster stack already destroyed).
variable "managed_cluster_name" {
  type        = string
  description = "ECS cluster name for managed instances; must match the cluster the service was created on."
  default     = "ecs-managed-instance-cluster"
}