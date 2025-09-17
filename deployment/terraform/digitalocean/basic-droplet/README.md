# DigitalOcean Basic Droplet

This Terraform configuration creates a single Ubuntu droplet on DigitalOcean using the cheapest available option.

## Prerequisites

1. **DigitalOcean Account**: Sign up at [DigitalOcean](https://www.digitalocean.com/)
2. **API Token**: Create an API token at [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
3. **SSH Key**: Add your SSH public key to DigitalOcean at [SSH Keys](https://cloud.digitalocean.com/account/security/keys)
4. **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads.html)

## Configuration

### Step 1: Bootstrap Setup
First, you must run the bootstrap configuration to create the DigitalOcean project and Space:

```bash
# Navigate to bootstrap directory
cd bootstrap/

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values:
# - do_token: Your DigitalOcean API token
# - region: DigitalOcean region (e.g., "nyc1")
# - project_name: Name for your project (will be created automatically)

# Create the project and Space
terraform init
terraform apply

# Get the project ID for main configuration
terraform output project_id
```

### Step 2: Main Configuration
After bootstrap completes, configure the main deployment:

```bash
# Navigate back to main directory
cd ../

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars
```

**Edit `terraform.tfvars`** with your values:
   ```hcl
   do_token = "your_actual_api_token_here"
   droplet_name = "my-laravel-app"
   region = "nyc1"
   ssh_key_name = "my-ssh-key"
   environment = "dev"
   do_project_id = "project-id-from-bootstrap-output"  # From bootstrap step
   do_spaces_access_key = "your-spaces-access-key"     # From DigitalOcean console
   do_spaces_secret_key = "your-spaces-secret-key"     # From DigitalOcean console
   ```

### Step 3: Deploy Infrastructure
After completing the bootstrap and configuration steps:

1. **Initialize Terraform with remote backend**:
   ```bash
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Destroy the resources** (when needed):
   ```bash
   terraform destroy
   ```

### Important Notes:
- **Bootstrap must be run first** - it creates the project and Space required for remote state
- **Project ID is required** - get it from bootstrap output
- **Spaces credentials are required** - generate them in DigitalOcean console after bootstrap

## Usage

This section covers additional usage information beyond the basic deployment steps.

## Droplet Specifications

- **Image**: Ubuntu 22.04 LTS
- **Size**: s-1vcpu-1gb (1 vCPU, 1GB RAM, 25GB SSD)
- **Cost**: ~$6/month
- **Features**: Basic droplet suitable for development and small applications

## Outputs

After deployment, Terraform will output:
- `droplet_ip`: The public IP address of your droplet
- `droplet_id`: The DigitalOcean ID of the droplet
- `droplet_name`: The name of the droplet
- `region`: The region where the droplet is deployed

## Connecting to Your Droplet

Once deployed, you can connect to your droplet via SSH:

```bash
ssh root@<droplet_ip>
```

Replace `<droplet_ip>` with the IP address from the Terraform output.

## Remote State Setup

This configuration uses DigitalOcean Spaces for remote state storage to enable team collaboration and consistent deployments between local and GitHub Actions.

### How It Works:
- **Bootstrap creates** the DigitalOcean project and Space
- **Main configuration** uses the Space for remote state storage
- **Each workspace** (dev, staging, production) gets its own state file in the Space
- **CI/CD pipelines** can access the same state as local development

### Required Credentials:
After running bootstrap, you need to:

1. **Generate Spaces Keys**:
   - Go to DigitalOcean → API → Spaces Keys
   - Generate New Key
   - Note down the access key and secret key

2. **Configure GitHub Secrets**:
   - `DO_SPACES_ACCESS_KEY` - Your Spaces access key
   - `DO_SPACES_SECRET_KEY` - Your Spaces secret key

3. **Add to terraform.tfvars**:
   ```hcl
   do_spaces_access_key = "your-spaces-access-key"
   do_spaces_secret_key = "your-spaces-secret-key"
   ```

### Bootstrap State Management:
- **Bootstrap state** remains local (not needed for CI/CD)
- **Main configuration** uses the Space for remote state
- **One-time setup** - bootstrap only needs to be run once

## Next Steps

After creating the droplet, you can:
1. Install Docker and Docker Compose
2. Deploy your Laravel application using the existing Docker setup