terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# GitHub provider configuration
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Create a simple GitHub repository
resource "github_repository" "main" {
  name        = var.repository_name
  description = var.repository_description
  
  # Repository settings
  visibility = var.repository_visibility
  
  # Initialize with README
  auto_init = var.auto_init
  
  # Repository features
  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_downloads   = var.has_downloads
  
  # Security settings
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  
  # Vulnerability alerts
  vulnerability_alerts = var.vulnerability_alerts
  
  # Archive on destroy
  archive_on_destroy = var.archive_on_destroy
  
  # Topics/tags
  topics = var.topics
  
  # Template repository (optional)
  template {
    owner      = var.template_owner
    repository = var.template_repository
  }
}

# Set default branch after repository creation
resource "github_repository_default_branch" "main" {
  count = var.default_branch != "main" ? 1 : 0
  
  repository = github_repository.main.name
  branch     = var.default_branch
  
  depends_on = [github_repository.main]
}

# Create branch protection rule for main branch (optional)
resource "github_branch_protection" "main" {
  count = var.enable_branch_protection ? 1 : 0
  
  repository_id = github_repository.main.node_id
  
  pattern = var.default_branch
  
  # Required status checks
  required_status_checks {
    strict   = var.require_status_checks
    contexts = var.required_status_check_contexts
  }
  
  # Required pull request reviews
  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    require_code_owner_reviews      = var.require_code_owner_reviews
    required_approving_review_count = var.required_approving_review_count
  }
  
  # Restrict pushes
  restricts_pushes = var.restrict_pushes
  
  # Allow force pushes
  allows_force_pushes = var.allows_force_pushes
  
  # Allow deletions
  allows_deletions = var.allows_deletions
}

# Create repository secrets (optional)
resource "github_actions_secret" "secrets" {
  for_each = var.repository_secrets
  
  repository  = github_repository.main.name
  secret_name = each.key
  plaintext_value = each.value
}

# Create repository variables (optional)
resource "github_actions_variable" "variables" {
  for_each = var.repository_variables
  
  repository  = github_repository.main.name
  variable_name = each.key
  value = each.value
}
