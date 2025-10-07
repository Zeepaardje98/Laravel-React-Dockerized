# Repository Information
output "repository_name" {
  description = "Name of the created repository"
  value       = github_repository.main.name
}

output "repository_full_name" {
  description = "Full name of the repository (owner/repo)"
  value       = github_repository.main.full_name
}

output "repository_url" {
  description = "URL of the repository"
  value       = github_repository.main.html_url
}

output "repository_clone_url_https" {
  description = "HTTPS clone URL of the repository"
  value       = github_repository.main.http_clone_url
}

output "repository_clone_url_ssh" {
  description = "SSH clone URL of the repository"
  value       = github_repository.main.ssh_clone_url
}

output "repository_git_url" {
  description = "Git URL of the repository"
  value       = github_repository.main.git_clone_url
}

output "repository_svn_url" {
  description = "SVN URL of the repository"
  value       = github_repository.main.svn_url
}

