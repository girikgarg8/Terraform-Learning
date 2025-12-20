resource "github_repository" "example" {
  name       = "first-repo-from-terraform"
  visibility = "public"
  auto_init  = true
}

output "terraform-first-repo-url" {
  value = github_repository.example.html_url
}
