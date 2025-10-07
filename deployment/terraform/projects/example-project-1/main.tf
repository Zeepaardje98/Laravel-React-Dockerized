terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {}
}

# GitHub provider configuration
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# GitHub repository (from template)
module "repo" {
  source = "../../modules/github-repository"

  github_token = var.github_token
  github_owner = var.github_owner

  repository_name        = var.repository_name
  repository_description = var.repository_description
  repository_visibility  = var.repository_visibility

  # Defaults already point to your template; override if needed
  # template_owner      = "Zeepaardje98"
  # template_repository = "Laravel-React-Dockerized"
}
