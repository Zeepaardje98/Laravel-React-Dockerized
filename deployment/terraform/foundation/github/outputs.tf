# Organization Members Output
output "organization_members" {
  description = "List of organization members"
  value = {
    for username, member in github_membership.members : username => {
      role = member.role
    }
  }
}

# Organization Teams Output
output "organization_teams" {
  description = "List of organization teams"
  value = {
    for team_name, team in github_team.teams : team_name => {
      id          = team.id
      name        = team.name
      description = team.description
      privacy     = team.privacy
    }
  }
}

# Team Memberships Output
output "team_memberships" {
  description = "List of team memberships"
  value = {
    for username, membership in github_team_membership.team_members : username => {
      team_id = membership.team_id
      role    = membership.role
    }
  }
}

# Organization Secrets Output (names only, not values)
output "organization_secrets" {
  description = "List of organization secrets (names only)"
  value = keys(github_actions_organization_secret.secrets)
  sensitive = true
}

# Organization Variables Output
output "organization_variables" {
  description = "List of organization variables"
  value = {
    for var_name, variable in github_actions_organization_variable.variables : var_name => {
      value      = variable.value
      visibility = variable.visibility
    }
  }
}

# Organization Webhooks Output
output "organization_webhooks" {
  description = "List of organization webhooks"
  value = {
    for webhook_name, webhook in github_organization_webhook.webhooks : webhook_name => {
      name         = webhook.name
      url          = webhook.url
      events       = webhook.events
      content_type = webhook.content_type
      active       = webhook.active
    }
  }
}

