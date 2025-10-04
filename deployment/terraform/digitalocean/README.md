# DigitalOcean Infrastructure

This directory contains Terraform configurations for deploying infrastructure on DigitalOcean.

## Structure

```
digitalocean/
├── organization/           # Shared organization infrastructure
├── basic-droplet/         # Basic droplet deployment
└── README.md             # This file
```

## Getting Started

### 1. Organization Setup (One-time)

First, set up your organization infrastructure:

```bash
cd organization/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform apply
```

This creates:
- DigitalOcean Project for organizing resources
- DigitalOcean Space for remote state storage
- Project assignment

### 2. Project Deployment

After organization setup, deploy individual projects:

```bash
cd basic-droplet/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with project_id from organization bootstrap
terraform init
terraform apply
```

## Available Configurations

### Organization Infrastructure
- **Purpose**: Shared foundation for all projects
- **Components**: Project, Space for remote state
- **Usage**: Run once, use across all projects

### Basic Droplet
- **Purpose**: Simple Ubuntu droplet deployment
- **Specs**: 1 vCPU, 1GB RAM, 25GB SSD (~$6/month)
- **Use Case**: Development, small applications

## Prerequisites

1. **DigitalOcean Account**: Sign up at [DigitalOcean](https://www.digitalocean.com/)
2. **API Token**: Create at [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
3. **SSH Key**: Add at [SSH Keys](https://cloud.digitalocean.com/account/security/keys)
4. **Spaces Access Keys**: Generate at [Spaces Keys](https://cloud.digitalocean.com/account/api/spaces)
5. **Terraform**: Install from [terraform.io](https://www.terraform.io/downloads.html)

## Security Notes

- Never commit `terraform.tfvars` files
- Use strong API tokens with minimal permissions
- Rotate credentials regularly
- Limit access to organization-level infrastructure

## Future Enhancements

The organization structure can be extended to include:
- Shared networking (VPCs, load balancers)
- Shared monitoring (alerts, dashboards)
- Shared security (firewall rules, access policies)
- Additional Spaces for different purposes
