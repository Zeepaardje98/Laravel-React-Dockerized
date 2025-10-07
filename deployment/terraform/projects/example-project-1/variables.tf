# GitHub Authentication
variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization name"
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
