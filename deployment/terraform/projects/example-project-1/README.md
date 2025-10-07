# Project Template

This directory contains a Terraform template for creating a complete project infrastructure.

## What This Template Creates

- **GitHub Repository**: A new repository in your organization
- **DigitalOcean Server**: A droplet for hosting your application
- **Project Configuration**: Basic project setup

## Usage

1. **Copy this template** to create a new project:
   ```bash
   cp -r project-template/ my-new-project/
   cd my-new-project/
   ```

2. **Configure your project**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your project details
   ```

3. **Deploy your project**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Prerequisites

- Foundation infrastructure must be deployed first
- GitHub organization must exist
- DigitalOcean account must be set up

## Configuration

Edit `terraform.tfvars` with your project-specific values:

- **Project details**: Name, description, environment
- **Repository settings**: Name, visibility, description
- **Server settings**: Size, region, image

## Next Steps

After deployment, you can:
- Clone your new repository
- SSH into your server
- Deploy your application
- Set up CI/CD pipelines
