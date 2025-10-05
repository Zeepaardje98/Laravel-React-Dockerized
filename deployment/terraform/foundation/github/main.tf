# Organization-level resources (shared infrastructure)
terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# GitHub provider configuration
provider "github" {
  token = var.github_token
  owner = var.github_organization
}

# Organization teams
resource "github_team" "teams" {
  for_each = var.organization_teams
  
  name        = each.value.name
  description = each.value.description
  privacy     = each.value.privacy
}

# Organization secrets
resource "github_actions_organization_secret" "secrets" {
  for_each = var.organization_secrets
  
  secret_name     = each.key
  visibility      = each.value.visibility
  plaintext_value = each.value.value
}

# Organization variables
resource "github_actions_organization_variable" "variables" {
  for_each = var.organization_variables
  
  variable_name = each.key
  value         = each.value.value
  visibility    = each.value.visibility
}
