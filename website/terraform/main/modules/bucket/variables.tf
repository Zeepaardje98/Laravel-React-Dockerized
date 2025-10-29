variable "name" {
  type    = string
  default = "super-dependable-bucket-name"
}

variable "region" {
  type    = string
  default = "ams3"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "key_name" {
  type    = string
  default = "scoped-key"
}
