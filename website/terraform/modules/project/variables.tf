variable "name" {
  type    = string
  default = "<project name>"
}

variable "description" {
  type    = string
  default = "<project description>"
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "resources" {
  type    = list(string)
  default = []
}
