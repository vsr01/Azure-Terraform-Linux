# Kubernetes VM Terraform Stack

This folder contains an isolated Terraform stack to deploy a Linux VM and required networking components in Azure.

## What this deploys

- Resource group
- Virtual network and subnet
- Public IP
- Network security group with SSH rule
- Network interface and NSG association
- Linux VM

## Defaults in this stack

- Region: `southcentralus`
- VM size: `Standard_F8amds_v7` (8 vCPU, 64 GiB RAM)
- Image:
  - `publisher = "Canonical"`
  - `offer = "0001-com-ubuntu-server-jammy"`
  - `sku = "22_04-lts-gen2"`
  - `version = "latest"`

## Prerequisites

- Terraform `>= 1.6.0`
- Azure CLI logged in (`az login`)
- Existing SSH key pair available locally

## Quick start

1. Select your subscription (replace with actual name/ID if needed):

```bash
az account set --subscription "Azure subscription 1"
az account show --output table
```

2. Create your local vars file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Update `terraform.tfvars`:
- Set `ssh_public_key_path` to your existing `.pub` key path
- Confirm `ssh_private_key_path` matches your private key path
- Tighten `ssh_allowed_cidr` from `0.0.0.0/0` to your source IP/CIDR

4. Initialize and validate:

```bash
terraform init
terraform validate
```

5. Plan and apply:

```bash
terraform plan
terraform apply
```

6. Connect using output:

```bash
terraform output ssh_command
```

## Destroy

```bash
terraform destroy
```
