output "project_id" {
  value       = module.project.project_id
  description = "Project ID created, used by other stages for organisational resources"
}

output "space_name" {
  value       = try(module.state_bucket.space_name, null)
  description = "Spaces bucket name, used for remote state storage"
}

output "bucket_spaces_access_key" {
  value       = module.state_bucket.spaces_access_key
  sensitive   = true
  description = "Bucket-specific Spaces access key for remote state backend"
}

output "bucket_spaces_secret_key" {
  value       = module.state_bucket.spaces_secret_key
  sensitive   = true
  description = "Bucket-specific Spaces secret key for remote state backend"
}

