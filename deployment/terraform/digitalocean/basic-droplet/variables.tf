variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
  default     = null
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "laravel-app"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "ssh_key_name" {
  description = "Name of the SSH key in DigitalOcean"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "laravel-react-app"
}
