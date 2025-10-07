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

# Create a GitHub repository from a template
resource "github_repository" "main" {
  name        = var.repository_name
  description = var.repository_description

  visibility = var.repository_visibility
  auto_init  = var.auto_init
  topics     = var.topics

  template {
    owner      = var.template_owner
    repository = var.template_repository
  }
}
