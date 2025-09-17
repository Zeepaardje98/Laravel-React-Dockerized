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

# Create droplet
resource "digitalocean_droplet" "app" {
  name     = "${var.project_name}-${var.environment}-${var.droplet_name}"
  image    = "ubuntu-22-04-x64"  # Latest Ubuntu LTS
  region   = var.region
  size     = "s-1vcpu-1gb"        # Cheapest droplet ($6/month)
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  tags = [
    "project:${var.project_name}",
    "environment:${var.environment}",
    "role:app"
  ]
}

