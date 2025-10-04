# Outputs for Stage 2 configuration

output "space_name" {
  description = "Name of the created Space"
  value       = digitalocean_spaces_bucket.terraform_state.name
}

output "space_region" {
  description = "Region of the created Space"
  value       = digitalocean_spaces_bucket.terraform_state.region
}

output "space_endpoint" {
  description = "Endpoint URL for the created Space"
  value       = digitalocean_spaces_bucket.terraform_state.endpoint
}

output "space_urn" {
  description = "URN of the created Space"
  value       = digitalocean_spaces_bucket.terraform_state.urn
}

output "project_id" {
  description = "ID of the project"
  value       = var.project_id
}

output "project_name" {
  description = "Name of the project"
  value       = data.digitalocean_project.existing.name
}

output "spaces_access_key" {
  description = "Generated bucket-specific Spaces access key"
  value       = digitalocean_spaces_key.terraform_state.access_key
  sensitive   = true
}

output "spaces_secret_key" {
  description = "Generated bucket-specific Spaces secret key"
  value       = digitalocean_spaces_key.terraform_state.secret_key
  sensitive   = true
}
