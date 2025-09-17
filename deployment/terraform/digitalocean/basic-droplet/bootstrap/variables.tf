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

variable "do_project_id" {
  description = "DigitalOcean project ID to assign resources to"
  type        = string
}
