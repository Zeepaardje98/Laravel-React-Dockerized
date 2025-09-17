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

# Get project information
data "digitalocean_project" "main" {
  id = var.do_project_id
}

# Create DigitalOcean Space for remote state
resource "digitalocean_spaces_bucket" "terraform_state" {
  name   = "terraform-state"
  region = var.region
}

# Assign Space to project
resource "digitalocean_project_resources" "space" {
  project   = var.do_project_id
  resources = [digitalocean_spaces_bucket.terraform_state.urn]
}
