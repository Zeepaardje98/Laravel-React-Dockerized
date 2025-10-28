variable "ssh_key_name" {
  type      = string
  sensitive = true
}

variable "name" {
  type    = string
  default = "example-droplet"
}

variable "region" {
  type    = string
  default = "ams3"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "image" {
  type    = string
  default = "ubuntu-22-04-x64"
}

data "digitalocean_ssh_key" "me" {
  name = var.ssh_key_name
}
