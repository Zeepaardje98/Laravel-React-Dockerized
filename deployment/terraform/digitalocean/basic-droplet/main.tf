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

# Get project information
data "digitalocean_project" "main" {
  id = var.do_project_id
}


# Create droplet
resource "digitalocean_droplet" "app" {
  name     = "${lower(replace(data.digitalocean_project.main.name, " ", "-"))}.${var.environment}.${var.droplet_name}"
  image    = "ubuntu-22-04-x64"  # Latest Ubuntu LTS
  region   = var.region
  size     = "s-1vcpu-1gb"        # Cheapest droplet ($6/month)
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  tags = [
    "project:${lower(replace(data.digitalocean_project.main.name, " ", "-"))}",
    "environment:${var.environment}",
    "role:app"
  ]
}

# Assign droplet to project
resource "digitalocean_project_resources" "droplet" {
  project   = var.do_project_id
  resources = [digitalocean_droplet.app.urn]
}


