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

# Get SSH key
data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

# Create project
resource "digitalocean_project" "main" {
  name        = var.project_name
  description = var.project_description
  purpose     = var.project_purpose
}


# Create droplet
resource "digitalocean_droplet" "app" {
  name     = "${lower(replace(digitalocean_project.main.name, " ", "-"))}.${var.environment}.${var.droplet_name}"
  image    = "ubuntu-22-04-x64"  # Latest Ubuntu LTS
  region   = var.region
  size     = "s-1vcpu-1gb"        # Cheapest droplet ($6/month)
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  tags = [
    "project:${lower(replace(digitalocean_project.main.name, " ", "-"))}",
    "environment:${var.environment}",
    "role:app"
  ]
}

# Assign droplet to project
resource "digitalocean_project_resources" "droplet" {
  project   = digitalocean_project.main.id
  resources = [digitalocean_droplet.app.urn]
}


