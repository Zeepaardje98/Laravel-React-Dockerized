resource "digitalocean_spaces_bucket" "my_bucket" {
  name   = var.name
  region = var.region
  acl    = var.acl
}
