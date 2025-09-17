# Bootstrap Configuration

This directory contains the bootstrap configuration for creating DigitalOcean Spaces for remote state storage.

## Purpose

The bootstrap configuration creates the foundational infrastructure needed for Terraform remote state storage:

- **DigitalOcean Space** - For storing Terraform state files
- **Project assignment** - Assigns the Space to your DigitalOcean project

## Usage

### Prerequisites

1. **DigitalOcean API Token** with the following permissions:
   - Droplets: Read and Write
   - SSH Keys: Read
   - Projects: Read and Write
   - Spaces: Read and Write

2. **DigitalOcean Project ID** - Get from your DigitalOcean console

### Setup

1. **Copy the example file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars** with your values:
   ```hcl
   do_token = "your-actual-token"
   region = "ams3"
   do_project_id = "your-actual-project-id"
   ```

3. **Initialize and apply**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Outputs

After successful deployment, this configuration outputs:

- `space_name` - Name of the created Space
- `space_region` - Region of the Space
- `space_endpoint` - Endpoint URL for the Space
- `space_urn` - URN of the Space

## Next Steps

After running the bootstrap configuration:

1. **Get Spaces credentials** from DigitalOcean Console → API → Spaces Keys
2. **Configure your main infrastructure** to use remote state
3. **Migrate to remote backend** in your main configuration

## Cleanup

This is a one-time setup. After migrating to remote state, you can:

- **Keep this configuration** for future reference
- **Remove it** if you no longer need it
- **Use it again** if you need to recreate the Space

## Security

- **Never commit** `terraform.tfvars` to version control
- **Use strong API tokens** with minimal required permissions
- **Rotate credentials** regularly
