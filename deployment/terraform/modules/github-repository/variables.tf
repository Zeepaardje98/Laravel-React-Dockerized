# GitHub Token - Personal Access Token with repo permissions
variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

# GitHub Owner (username or organization)
variable "github_owner" {
  description = "GitHub username or organization name"
  type        = string
}

# Repository Configuration
variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "repository_description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = ""
}

variable "repository_visibility" {
  description = "Repository visibility (public, private, internal)"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.repository_visibility)
    error_message = "Repository visibility must be one of: public, private, internal."
  }
}

variable "auto_init" {
  description = "Initialize the repository with a README"
  type        = bool
  default     = true
}

variable "default_branch" {
  description = "Default branch name"
  type        = string
  default     = "main"
}

# Repository Features
variable "has_issues" {
  description = "Enable GitHub Issues"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enable GitHub Projects"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Enable GitHub Wiki"
  type        = bool
  default     = false
}

variable "has_downloads" {
  description = "Enable GitHub Downloads"
  type        = bool
  default     = false
}

# Merge Settings
variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merges"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merge"
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "Delete branch on merge"
  type        = bool
  default     = true
}

# Security Settings
variable "vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "archive_on_destroy" {
  description = "Archive repository on destroy instead of deleting"
  type        = bool
  default     = true
}

# Topics/Tags
variable "topics" {
  description = "Repository topics/tags"
  type        = list(string)
  default     = []
}

# Template Repository (optional)
variable "template_owner" {
  description = "Owner of the template repository"
  type        = string
  default     = ""
}

variable "template_repository" {
  description = "Name of the template repository"
  type        = string
  default     = ""
}

# Branch Protection Settings
variable "enable_branch_protection" {
  description = "Enable branch protection for the default branch"
  type        = bool
  default     = false
}

variable "require_status_checks" {
  description = "Require status checks to pass before merging"
  type        = bool
  default     = false
}

variable "required_status_check_contexts" {
  description = "List of status check contexts that must pass"
  type        = list(string)
  default     = []
}

variable "dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed"
  type        = bool
  default     = true
}

variable "require_code_owner_reviews" {
  description = "Require reviews from code owners"
  type        = bool
  default     = false
}

variable "required_approving_review_count" {
  description = "Number of approving reviews required"
  type        = number
  default     = 1
}

variable "restrict_pushes" {
  description = "Restrict pushes to the protected branch"
  type        = bool
  default     = false
}

variable "allows_force_pushes" {
  description = "Allow force pushes to the protected branch"
  type        = bool
  default     = false
}

variable "allows_deletions" {
  description = "Allow deletions of the protected branch"
  type        = bool
  default     = false
}

# Repository Secrets
variable "repository_secrets" {
  description = "Repository secrets for GitHub Actions"
  type        = map(string)
  default     = {}
  sensitive   = true
}

# Repository Variables
variable "repository_variables" {
  description = "Repository variables for GitHub Actions"
  type        = map(string)
  default     = {}
}
