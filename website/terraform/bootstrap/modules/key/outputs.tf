output "admin_access_key" {
  value     = digitalocean_spaces_key.admin_key.access_key
  sensitive = true
}

output "admin_secret_key" {
  value     = digitalocean_spaces_key.admin_key.secret_key
  sensitive = true
}
