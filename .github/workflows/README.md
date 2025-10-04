# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automated CI/CD processes.

## Available Workflows

### Terraform Deploy (`terraform-deploy.yml`)
Automated infrastructure deployment using Terraform with support for multiple environments and cloud providers.

**Features:**
- **Automatic deployments** on branch pushes (staging, production)
- **Manual deployments** with environment selection
- **Multi-provider support** (DigitalOcean, AWS, GCP)
- **Environment isolation** using Terraform workspaces
- **Remote state management** for team collaboration

## Setup Instructions

### 1. Repository Secrets
Configure these secrets in your repository settings (Settings → Secrets and variables → Actions → Secrets):

#### DigitalOcean:
- `DO_TOKEN` - Your DigitalOcean API token
- `DO_SPACES_ACCESS_KEY` - DigitalOcean Spaces access key ID (required for remote state)
- `DO_SPACES_SECRET_KEY` - DigitalOcean Spaces secret key (required for remote state)

**Note**: Spaces credentials must be created manually in DigitalOcean Console → API → Spaces Keys before using this workflow.

#### AWS:
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key

#### GCP:
- `GCP_CREDENTIALS` - GCP service account JSON

### 2. Repository Variables
Configure these variables in your repository settings (Settings → Secrets and variables → Actions → Variables):

#### DigitalOcean:
- `DO_DROPLET_NAME` - Droplet name (e.g., "my-app-staging")
- `DO_REGION` - DigitalOcean region (e.g., "nyc1")
- `DO_SSH_KEY_NAME` - SSH key name (e.g., "my-laptop-key")

#### AWS:
- `AWS_REGION` - AWS region (e.g., "us-east-1")

#### GCP:
- `GCP_PROJECT_ID` - GCP project ID (e.g., "my-project-123")

#### Common:
- `PROJECT_NAME` - Project name (e.g., "my-app")
- `PROVIDER` - Cloud provider (e.g., "digitalocean")
- `TERRAFORM_CONFIG` - Terraform configuration directory (e.g., "basic-droplet")

## Usage

### Automatic Deployments
The workflow automatically triggers on:
- **Push to `staging` branch** → deploys to staging environment
- **Push to `production` branch** → deploys to production environment

### Manual Deployments
You can manually trigger deployments with custom parameters:
1. Go to Actions → Terraform Deploy
2. Click "Run workflow"
3. Select:
   - **Environment**: dev, staging, or production
   - **Provider**: digitalocean, aws, or gcp
