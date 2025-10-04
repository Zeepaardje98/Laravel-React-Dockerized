# DigitalOcean Basic Droplet

This Terraform configuration creates a single Ubuntu droplet on DigitalOcean using the cheapest available option.

## Prerequisites

1. **DigitalOcean Account**: Sign up at [DigitalOcean](https://www.digitalocean.com/)
2. **API Token**: Create an API token at [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
3. **SSH Key**: Add your SSH public key to DigitalOcean at [SSH Keys](https://cloud.digitalocean.com/account/security/keys)
4. **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads.html)

## Configuration

### Step 1: Create Spaces Access Keys
**IMPORTANT**: You must create DigitalOcean Spaces access keys manually first:

1. Go to [DigitalOcean Console → API → Spaces Keys](https://cloud.digitalocean.com/account/api/spaces)
2. Click "Generate New Key"
3. Name it something like "terraform-bootstrap"
4. Copy the Access Key ID and Secret Key

### Step 2: Optional - Organization Setup (for shared infrastructure)
If you want to use shared organization infrastructure, run the organization configuration:

```bash
# Navigate to organization directory
cd ../organization/

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values:
# - do_token: Your DigitalOcean API token
# - region: DigitalOcean region (e.g., "nyc1")
# - project_name: Name for your organization project (will be created automatically)
# - do_spaces_access_id: Your Spaces access key ID (from Step 1)
# - do_spaces_secret_key: Your Spaces secret key (from Step 1)

# Create the project and Space
terraform init
terraform apply
```

### Step 3: Main Configuration
Configure the main deployment:

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars
```

**Edit `terraform.tfvars`** with your values

### Step 4: Deploy Infrastructure
After completing the configuration steps:

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
- **Project creation** - This configuration creates its own DigitalOcean project
- **Self-contained** - No external dependencies on organization infrastructure
- **Spaces credentials** - Only needed if you want to use remote state storage
- **Standalone deployment** - Can be deployed independently

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
- `project_id`: The ID of the created project
- `project_name`: The name of the created project

## Connecting to Your Droplet

Once deployed, you can connect to your droplet via SSH:

```bash
ssh root@<droplet_ip>
```

Replace `<droplet_ip>` with the IP address from the Terraform output.

## Remote State Setup

This configuration uses DigitalOcean Spaces for remote state storage to enable team collaboration and consistent deployments between local and GitHub Actions.

### How It Works:
- **Self-contained project** - Creates its own DigitalOcean project
- **Optional remote state** - Can use DigitalOcean Spaces for remote state storage
- **Each workspace** (dev, staging, production) gets its own state file
- **CI/CD pipelines** can access the same state as local development
- **Independent deployment** - No dependencies on external infrastructure

### Optional Remote State Setup:
If you want to use remote state storage:

1. **Generate Spaces Keys**:
   - Go to DigitalOcean → API → Spaces Keys
   - Generate New Key
   - Note down the access key and secret key

2. **Configure GitHub Secrets** (for CI/CD):
   - `DO_SPACES_ACCESS_KEY` - Your Spaces access key
   - `DO_SPACES_SECRET_KEY` - Your Spaces secret key

3. **Add to terraform.tfvars**:
   ```hcl
   do_spaces_access_key = "your-spaces-access-key"
   do_spaces_secret_key = "your-spaces-secret-key"
   ```

4. **Configure backend** in main.tf:
   ```hcl
   terraform {
     backend "s3" {
       endpoint   = "your-space-endpoint"
       bucket     = "your-space-name"
       key        = "basic-droplet/terraform.tfstate"
       region     = "your-space-region"
       # ... other backend config
     }
   }
   ```

### State Management:
- **Local state** - Default behavior, state stored locally
- **Optional remote state** - Can use DigitalOcean Spaces for team collaboration
- **Self-contained** - No dependencies on external organization infrastructure
- **Independent** - Can be deployed and managed separately

## Next Steps

After creating the droplet, you can:
1. Install Docker and Docker Compose
2. Deploy your Laravel application using the existing Docker setup