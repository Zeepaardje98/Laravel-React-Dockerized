# Organization Infrastructure

This directory contains the foundational infrastructure configuration for your DigitalOcean organization. This infrastructure is shared across all projects and environments.

## Purpose

The organization configuration creates the foundational infrastructure needed for Terraform remote state storage:

- **DigitalOcean Space** - For storing Terraform state files across all projects
- **Default project assignment** - Assigns the Space to DigitalOcean's default project

## Usage

### Prerequisites

1. **DigitalOcean API Token** with the following permissions:
   - Projects: Read and Write (to create project)
   - Spaces: Read and Write (to create Space)

2. **DigitalOcean Spaces Access Keys** - Create these manually in DigitalOcean Console:
   - Go to DigitalOcean Console → API → Spaces Keys
   - Click "Generate New Key"
   - Name it something like "terraform-bootstrap"
   - Copy the Access Key ID and Secret Key

### Setup

1. **Copy the example file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars** with your values

3. **Initialize and apply**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Outputs

After successful deployment, this configuration outputs:

- `project_id` - **IMPORTANT**: Use this in all your project terraform.tfvars files
- `project_name` - Name of the created project
- `space_name` - Name of the created Space
- `space_region` - Region of the Space
- `space_endpoint` - Endpoint URL for the Space
- `space_urn` - URN of the Space

## Using with Projects

After running the foundation configuration, all your project configurations (like `basic-droplet`) should:

1. **Reference the project_id** in their terraform.tfvars
2. **Use remote state** pointing to the created Space
3. **Assign resources** to the organization project

Example project terraform.tfvars:
```hcl
# Organization details
do_project_id = "your-project-id-from-foundation-output"

# Remote state configuration
terraform {
  backend "s3" {
    endpoint   = "your-space-endpoint"
    bucket     = "your-space-name"
    key        = "projects/basic-droplet/terraform.tfstate"
    region     = "your-space-region"
    # ... other backend config
  }
}
```

## Security

- **Never commit** `terraform.tfvars` to version control
- **Use strong API tokens** with minimal required permissions
- **Rotate credentials** regularly
- **Limit access** to organization-level infrastructure

## Future Enhancements

This organization structure can be extended to include:

- **Shared networking** (VPCs, load balancers)
- **Shared monitoring** (alerts, dashboards)
- **Shared security** (firewall rules, access policies)
- **Shared storage** (additional Spaces for different purposes)
