# Terraform Infrastructure Organization

This directory contains Terraform configurations organized by deployment frequency and scope.

## Directory Structure

```
deployment/terraform/
├── foundation/                    # One-time setup (run once)
│   ├── github/
│   │   └── organization/          # GitHub org, teams, members, secrets
│   └── digitalocean/
│       └── organization/           # DO teams, projects, shared resources
├── projects/                      # Per-project setup (run per project)
│   ├── github/
│   │   └── repository-module/     # Reusable repo template
│   └── digitalocean/
│       ├── server-module/         # Reusable server template
│       └── projects/              # Individual project configs
│           ├── project-alpha/
│           │   ├── github-repo/
│           │   └── digitalocean-server/
│           └── project-beta/
│               ├── github-repo/
│               └── digitalocean-server/
└── modules/                      # Shared reusable modules
    ├── github-repository/
    ├── digitalocean-droplet/
    └── digitalocean-project/
```

## Deployment Strategy

### **Phase 1: Foundation Setup (Run Once)**
Deploy organization-level infrastructure that will be shared across all projects:

```bash
# 1. Set up GitHub organization
cd foundation/github/organization/
terraform init && terraform apply

# 2. Set up DigitalOcean organization
cd foundation/digitalocean/organization/
terraform init && terraform apply
```

### **Phase 2: Project Setup (Run Per Project)**
For each new project, create the necessary resources:

```bash
# Example: Setting up "project-alpha"
cd projects/digitalocean/projects/project-alpha/

# Create GitHub repository
cd github-repo/
terraform init && terraform apply

# Create DigitalOcean server
cd ../digitalocean-server/
terraform init && terraform apply
```

## Resource Categories

### **Foundation Resources (One-time)**
- **GitHub**: Organization, teams, members, organization secrets/variables
- **DigitalOcean**: Teams, projects, shared networking, monitoring

### **Project Resources (Per-project)**
- **GitHub**: Individual repositories, repository-specific secrets
- **DigitalOcean**: Droplets, databases, load balancers, project-specific resources

## Benefits of This Structure

✅ **Clear Separation**: Foundation vs project resources
✅ **Reusability**: Modules can be shared across projects
✅ **Scalability**: Easy to add new projects
✅ **State Isolation**: Each project has its own state
✅ **Team Autonomy**: Different teams can manage their own projects
✅ **Cost Tracking**: Easy to track costs per project

## Getting Started

1. **Set up foundation first** (GitHub org, DO organization)
2. **Create your first project** using the templates
3. **Scale by adding more projects** as needed

## Best Practices

- **Foundation first**: Always set up organization-level resources before projects
- **Module reuse**: Use the provided modules for consistency
- **State management**: Use remote state for team collaboration
- **Naming conventions**: Follow consistent naming across all resources
- **Documentation**: Each module should have clear documentation