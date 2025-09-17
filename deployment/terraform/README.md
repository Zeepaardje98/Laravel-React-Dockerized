# Terraform Deployments

This directory contains Terraform configurations for deploying infrastructure across multiple cloud providers.

## Available Providers

### DigitalOcean
- **Basic Droplet** (`digitalocean/basic-droplet/`) - Single Ubuntu droplet (~$6/month)
- **Future Configurations**: Managed database, load balancer, Kubernetes cluster

### Future Providers
- **AWS** - EC2 instances, RDS databases, EKS clusters
- **Google Cloud** - Compute Engine, Cloud SQL, GKE clusters

## Quick Start

1. **Choose a configuration**:
   ```bash
   cd digitalocean/basic-droplet/
   ```

2. **Configure variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Multiple Deployments

Use **Terraform Workspaces** for managing multiple environments:

```bash
# Create workspaces for different environments
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Deploy to specific environment
terraform workspace select dev
terraform apply -var="environment=dev"

terraform workspace select staging
terraform apply -var="environment=staging"

terraform workspace select prod
terraform apply -var="environment=prod"
```

## GitHub Actions Integration

The repository includes GitHub Actions workflows for automated deployments:

- **Staging deployment** - automatic on push to `staging` branch
- **Production deployment** - automatic on push to `production` branch
- **Manual deployment** with environment selection (dev, staging, or production)
- **Secure secrets management** via GitHub Secrets
- **Dev environment** - deploy via GitHub Actions or manually using workspaces

See `.github/workflows/terraform-deploy.yml` for details.

## Configuration Management

### Environment Variables
Use the provided script to set environment variables:
```bash
source .github/workflows/scripts/set-env.sh
```

### GitHub Configuration

#### Repository Secrets (Settings → Secrets and variables → Actions → Secrets)
**DigitalOcean:**
- `DO_TOKEN` - Your DigitalOcean API token

**AWS:**
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key

**GCP:**
- `GCP_CREDENTIALS` - GCP service account JSON

#### Repository Variables (Settings → Secrets and variables → Actions → Variables)
**DigitalOcean:**
- `DO_DROPLET_NAME` - Droplet name (e.g., "my-app-staging")
- `DO_REGION` - DigitalOcean region (e.g., "nyc1")
- `DO_SSH_KEY_NAME` - SSH key name (e.g., "my-laptop-key")

**AWS:**
- `AWS_REGION` - AWS region (e.g., "us-east-1")

**GCP:**
- `GCP_PROJECT_ID` - GCP project ID (e.g., "my-project-123")

**Common:**
- `PROJECT_NAME` - Project name (e.g., "my-app")
- `PROVIDER` - Cloud provider (e.g., "digitalocean")
- `TERRAFORM_CONFIG` - Terraform configuration directory (e.g., "basic-droplet")

## Directory Structure

```
deployment/terraform/
├── digitalocean/
│   └── basic-droplet/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars.example
│       └── README.md
├── aws/              # Future
├── gcp/              # Future
├── .gitignore
└── README.md         # This file
```

## Best Practices

1. **State Management**: Use remote state storage for team collaboration
2. **Secrets**: Never commit API tokens or sensitive data
3. **Tagging**: All resources are tagged with project and environment
4. **Naming**: Use consistent naming conventions
5. **Documentation**: Each configuration has its own README

## Troubleshooting

- **State Issues**: Use `terraform refresh` if resources are out of sync
- **Provider-specific issues**: See individual provider READMEs for detailed troubleshooting

## Adding New Configurations

To add a new configuration:

1. Create a new directory: `mkdir new-provider/new-config/`
2. Copy the basic structure from `digitalocean/basic-droplet/`
3. Modify the Terraform files as needed
4. Update this README to document the new configuration
5. Add any new secrets to GitHub Actions workflow
