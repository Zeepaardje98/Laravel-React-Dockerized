# Bootstrap configuration to create DigitalOcean Space for remote state
# Run this first to create the Space, then migrate to remote backend

terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create or get project information
resource "digitalocean_project" "main" {
  name        = var.project_name
  description = "Project for ${var.project_name} infrastructure"
  purpose     = "Web Application"
  environment = "Development"
}

# Create DigitalOcean Space for remote state
resource "digitalocean_spaces_bucket" "terraform_state" {
  name   = "terraform-state"
  region = var.region
}

# Assign Space to project
resource "digitalocean_project_resources" "space" {
  project   = digitalocean_project.main.id
  resources = [digitalocean_spaces_bucket.terraform_state.urn]
}
