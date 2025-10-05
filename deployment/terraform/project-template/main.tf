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
}

# GitHub provider configuration
provider "github" {
  token = var.github_token
  owner = var.github_organization
}

# DigitalOcean provider configuration
provider "digitalocean" {
  token = var.digitalocean_token
}

# Project resources will be added here
