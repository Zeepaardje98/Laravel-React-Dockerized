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
  value       = github_repository.main.clone_url
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

# Repository Configuration
output "repository_description" {
  description = "Description of the repository"
  value       = github_repository.main.description
}

output "repository_visibility" {
  description = "Visibility of the repository"
  value       = github_repository.main.visibility
}

output "repository_default_branch" {
  description = "Default branch of the repository"
  value       = github_repository.main.default_branch
}

output "repository_topics" {
  description = "Topics/tags of the repository"
  value       = github_repository.main.topics
}

# Repository Features
output "repository_has_issues" {
  description = "Whether the repository has issues enabled"
  value       = github_repository.main.has_issues
}

output "repository_has_projects" {
  description = "Whether the repository has projects enabled"
  value       = github_repository.main.has_projects
}

output "repository_has_wiki" {
  description = "Whether the repository has wiki enabled"
  value       = github_repository.main.has_wiki
}

output "repository_has_downloads" {
  description = "Whether the repository has downloads enabled"
  value       = github_repository.main.has_downloads
}

# Security Features
output "repository_vulnerability_alerts" {
  description = "Whether vulnerability alerts are enabled"
  value       = github_repository.main.vulnerability_alerts
}

# Branch Protection
output "branch_protection_enabled" {
  description = "Whether branch protection is enabled"
  value       = var.enable_branch_protection
}

# Repository ID (for use in other resources)
output "repository_id" {
  description = "ID of the repository"
  value       = github_repository.main.id
}

output "repository_node_id" {
  description = "Node ID of the repository"
  value       = github_repository.main.node_id
}
