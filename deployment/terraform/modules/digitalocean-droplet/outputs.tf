output "droplet_ip" {
  description = "Public IP address of the droplet"
  value       = digitalocean_droplet.app.ipv4_address
}

output "droplet_id" {
  description = "ID of the droplet"
  value       = digitalocean_droplet.app.id
}

output "droplet_name" {
  description = "Name of the droplet"
  value       = digitalocean_droplet.app.name
}

output "region" {
  description = "Region of the droplet"
  value       = digitalocean_droplet.app.region
}

output "project_id" {
  description = "ID of the created project"
  value       = digitalocean_project.main.id
}

output "project_name" {
  description = "Name of the created project"
  value       = digitalocean_project.main.name
}