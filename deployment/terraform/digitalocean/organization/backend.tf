terraform {
  # Remote state backend in DigitalOcean Spaces (S3-compatible)
  backend "s3" {
    endpoints = {
      s3 = "https://ams3.digitaloceanspaces.com"
    }

    bucket = "organization-infrastructure.terraform-state-bucket"
    key    = "terraform/organization/state.tfstate"
    profile = "digitalocean-spaces"

    # AWS-specific checks disabled for Spaces
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"

    # Enable lockfile-based state locking in Spaces (Terraform >= 1.11)
    use_lockfile = true
  }
}

