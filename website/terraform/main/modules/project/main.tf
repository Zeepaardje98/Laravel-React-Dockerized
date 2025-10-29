resource "digitalocean_project" "my_project" {
  name        = var.name
  description = var.description
  environment = var.environment
}
