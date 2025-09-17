variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
  default     = null
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "droplet"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "ssh_key_name" {
  description = "Name of the SSH key in DigitalOcean"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "do_project_id" {
  description = "DigitalOcean project ID to assign resources to"
  type        = string
}

variable "do_spaces_access_key" {
  description = "DigitalOcean Spaces access key for remote state"
  type        = string
  sensitive   = true
  default     = null
}

variable "do_spaces_secret_key" {
  description = "DigitalOcean Spaces secret key for remote state"
  type        = string
  sensitive   = true
  default     = null
}