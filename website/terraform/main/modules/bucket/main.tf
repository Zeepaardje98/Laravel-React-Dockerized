resource "digitalocean_spaces_bucket" "my_bucket" {
  name   = var.name
  region = var.region
  acl    = var.acl
}


resource "digitalocean_spaces_key" "scoped" {
  name = var.key_name

  grant {
    bucket     = digitalocean_spaces_bucket.my_bucket.name
    permission = "readwrite"
  }
}
