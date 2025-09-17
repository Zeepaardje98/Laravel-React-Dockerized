# Bootstrap Configuration

This directory contains the bootstrap configuration for creating DigitalOcean Spaces for remote state storage.

## Purpose

The bootstrap configuration creates the foundational infrastructure needed for Terraform remote state storage:

- **DigitalOcean Project** - Organizes all your infrastructure resources
- **DigitalOcean Space** - For storing Terraform state files
- **Project assignment** - Assigns the Space to your DigitalOcean project

## Usage

### Prerequisites

1. **DigitalOcean API Token** with the following permissions:
   - Projects: Read and Write (to create project)
   - Spaces: Read and Write (to create Space)

2. **Project Name** - Choose a name for your DigitalOcean project (will be created automatically)

### Setup

1. **Copy the example file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars** with your values:

3. **Initialize and apply**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Outputs

After successful deployment, this configuration outputs:

- `project_id` - **IMPORTANT**: Use this in your main terraform.tfvars
- `project_name` - Name of the created project
- `space_name` - Name of the created Space
- `space_region` - Region of the Space
- `space_endpoint` - Endpoint URL for the Space
- `space_urn` - URN of the Space

## Next Steps

After running the bootstrap configuration:

1. **Save the project_id** from the output (you'll need this for main config)
2. **Get Spaces credentials** from DigitalOcean Console → API → Spaces Keys
3. **Configure your main infrastructure** with the project_id and Spaces credentials
4. **Deploy your main infrastructure** using the remote state

## Security

- **Never commit** `terraform.tfvars` to version control
- **Use strong API tokens** with minimal required permissions
- **Rotate credentials** regularly
