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

2. **Follow provider-specific setup**:
   Each provider has its own setup instructions. See the individual provider READMEs for detailed steps.

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

The repository includes GitHub Actions workflows for automated deployments. See `.github/workflows/README.md` for detailed setup instructions and configuration.

**Features:**
- **Automatic deployments** on branch pushes
- **Manual deployments** with environment selection

## Directory Structure

```
deployment/terraform/
├── digitalocean/
│   └── basic-droplet/
│       ├── bootstrap/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   ├── terraform.tfvars.example
│       │   └── README.md
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

1. **State Management**: Remote state storage configured for team collaboration
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
