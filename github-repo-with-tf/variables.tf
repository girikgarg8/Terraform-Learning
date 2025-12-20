variable "token" {
  type        = string
  description = "GitHub Personal Access Token"
  sensitive   = true
  # DO NOT put the actual token here!
  # Put it in terraform.tfvars (which is in .gitignore)
}