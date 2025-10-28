resource "digitalocean_droplet" "my_droplet" {
  name     = var.name
  region   = var.region
  size     = var.size
  image    = var.image
  ssh_keys = [data.digitalocean_ssh_key.me.id]
}
