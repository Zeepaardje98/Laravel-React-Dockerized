# Outputs for bootstrap configuration

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
