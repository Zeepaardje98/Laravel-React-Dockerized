# DigitalOcean Basic Droplet

This Terraform configuration creates a single Ubuntu droplet on DigitalOcean using the cheapest available option.

## Prerequisites

1. **DigitalOcean Account**: Sign up at [DigitalOcean](https://www.digitalocean.com/)
2. **API Token**: Create an API token at [DigitalOcean API Tokens](https://cloud.digitalocean.com/account/api/tokens)
3. **SSH Key**: Add your SSH public key to DigitalOcean at [SSH Keys](https://cloud.digitalocean.com/account/security/keys)
4. **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads.html)

## Configuration

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   ```hcl
   do_token = "your_actual_api_token_here"
   droplet_name = "my-laravel-app"
   region = "nyc1"
   ssh_key_name = "my-ssh-key"
   environment = "dev"
   project_name = "my-project"
   ```

## Usage

1. **Initialize Terraform**:
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

4. **Destroy the resources**:
   ```bash
   terraform destroy
   ```

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



## Next Steps

After creating the droplet, you can:
1. Install Docker and Docker Compose
2. Deploy your Laravel application using the existing Docker setup