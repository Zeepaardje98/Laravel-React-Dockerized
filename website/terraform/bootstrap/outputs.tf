output "admin_access_key" {
  value     = module.key.admin_access_key
  sensitive = true
}

output "admin_secret_key" {
  value     = module.key.admin_secret_key
  sensitive = true
}
