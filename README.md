# southern-cross-cloud
southern-cross-cloud-infrastructure


Azure Infrastructure as Code (Terraform)
Overview

This repository contains Terraform code to provision Azure infrastructure using Infrastructure as Code (IaC).

The infrastructure includes:

Azure Virtual Machine (VM) – Hosts the required workload.
Azure Key Vault – Securely stores and manages secrets, keys, and sensitive configuration.
Azure Bastion – Provides secure SSH/RDP access to the VM through the Azure portal without exposing the VM's public IP.
Azure Virtual Network (VNet) – Provides network isolation and connectivity.
Network Security Groups (NSGs) – Control inbound and outbound network traffic.
Architecture
                Azure Subscription
                        |
                 Resource Group
                        |
             +----------+----------+
             |                     |
          Key Vault              VNet
                                   |
                         +---------+---------+
                         |                   |
                    AzureBastionSubnet    VM Subnet
                         |                   |
                    Azure Bastion       Linux/Windows VM
                         |
                  Secure VM Access

Prerequisites

Install the following tools before deployment:

Terraform
Azure CLI
An Azure subscription with appropriate permissions

Authenticate with Azure:

az login
az account set --subscription "<SUBSCRIPTION_ID>"
az account show

Repository Structure
.
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── versions.tf
├── .gitignore
└── README.md


Adjust the structure to match the actual files in your repository.

Infrastructure Components
1. Azure Virtual Machine
Deploys a Linux or Windows virtual machine
Uses a subnet within an Azure Virtual Network.
Restricts direct public exposure where configured.
Supports administrative access through Azure Bastion.
2. Azure Key Vault
Stores secrets and sensitive configuration.
Supports Azure RBAC or configured access policies.
Can be used to manage VM-related credentials and application secrets.
Access should be limited to authorized identities.
Security: Avoid hardcoding secrets in Terraform files or committing secret values to Git. Terraform state can also contain sensitive values and must be secured.

3. Azure Bastion
Enables browser-based SSH/RDP connectivity through the Azure portal.
Avoids requiring a public IP address on the VM for Bastion-based access.
Requires a dedicated subnet named AzureBastionSubnet.
Requires appropriate Bastion and network configuration.
Deployment Instructions
Step 1: Clone the repository

git clone <YOUR_REPOSITORY_URL>
cd <YOUR_REPOSITORY_DIRECTORY>
Step 2: Initialize Terraform

terraform init
Step 3: Format and validate

terraform fmt -recursive
terraform validate
Step 4: Configure variables
Update your local terraform.tfvars file with the required values.

Example:


location            = "Central India"
resource_group_name = "rg-terraform-demo"
These are example values; use only variables that are declared in your Terraform configuration.

Step 5: Review the deployment plan

terraform plan -out=tfplan
Review the proposed changes before proceeding.

Step 6: Deploy the infrastructure

terraform apply tfplan
Step 7: Review outputs

terraform output
Use the Azure portal to verify the VM, Key Vault, VNet, and Bastion resources.

Security Scanning
Run Terraform security and quality checks before deployment:


terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint --init
tflint
tfsec . || true
The || true command allows the shell step to continue even when tfsec exits with a non-zero status. Review and remediate security findings rather than treating them as resolved.

Cleanup
To delete resources managed by this Terraform configuration:


terraform plan -destroy
terraform destroy
Review the destruction plan carefully before confirming.

Security Best Practices
Do not commit credentials, private keys, or secret values.
Exclude terraform.tfvars, state files, and plan files from Git where they contain sensitive information.
Use Azure RBAC and least-privilege access.
Restrict Key Vault access and enable appropriate logging.
Avoid public IP addresses on VMs unless required.
Use a secured remote Terraform backend with access controls and state locking.
Review Terraform security scan findings before deployment.
Disclaimer
This repository is an Infrastructure as Code example. Review the Terraform configuration, network rules, access permissions, and security settings before deploying resources to production.
