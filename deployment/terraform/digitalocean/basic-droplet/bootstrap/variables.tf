# Variables for bootstrap configuration

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "project_name" {
  description = "Name for the DigitalOcean project"
  type        = string
}
