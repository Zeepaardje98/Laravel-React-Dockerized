variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
  default     = null
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key in DigitalOcean"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the DigitalOcean project"
  type        = string
}

variable "project_description" {
  description = "Description of the DigitalOcean project"
  type        = string
  default     = "Project for basic droplet deployment"
}

variable "project_purpose" {
  description = "Purpose of the DigitalOcean project"
  type        = string
  default     = "Web Application"
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