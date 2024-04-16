## Azure Linux VM with Terraform (Beginner Guide)

This repository provisions one Ubuntu Linux VM in Azure with:
- a resource group
- virtual network + subnet
- public IP
- network security group (SSH rule)
- network interface
- Linux VM with SSH key login

The layout is intentionally flat and simple.

## Project files

- `main.tf`: all Azure resources
- `variables.tf`: input variables
- `outputs.tf`: useful outputs (`vm_public_ip`, `ssh_command`)
- `terraform.tfvars.example`: template for real values
- `gen-ssh-key.sh`: helper script to create SSH key pair
- `.gitignore`: excludes state and local var files

## Prerequisites

Install:
- Terraform (`terraform -version`)
- Azure CLI (`az version`)

Login:

```bash
az login
az account show
```

If you have multiple subscriptions, set the one you want:

```bash
az account set --subscription "<subscription-id-or-name>"
```

## End-to-end flow

### 1) Generate SSH key pair

```bash
./gen-ssh-key.sh
```

This creates:
- private key: `~/.ssh/azure-dev-vm`
- public key: `~/.ssh/azure-dev-vm.pub`

### 2) Create your local variables file

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set at least:
- `ssh_public_key_path` to your real `.pub` path (example: `/Users/vijay/.ssh/azure-dev-vm.pub`)
- `location` and `vm_size` as needed
- `tags.owner` to your name/team

Important:
- Keep `ssh_public_key = ""` when using `ssh_public_key_path`.
- You may also provide full key text directly in `ssh_public_key`.

### 3) Initialize Terraform

```bash
terraform init
```

### 4) Review execution plan

```bash
terraform plan
```

### 5) Apply infrastructure

```bash
terraform apply
```

When prompted, type `yes`.

### 6) Get connection details

```bash
terraform output
```

Expected outputs include:
- `vm_public_ip`
- `ssh_command`

### 7) SSH into the VM

Use output command directly, or:

```bash
ssh -i ~/.ssh/azure-dev-vm azureuser@<vm_public_ip>
```

## Current defaults (from example)

- Region: `eastus2`
- VM size: `Standard_D4as_v7` (16 GB RAM)
- OS image: Ubuntu 22.04 Gen2
- SSH access CIDR: `0.0.0.0/0` (open to all IPs)

## Security recommendations

1. Restrict SSH:
   - Replace `ssh_allowed_cidr = "0.0.0.0/0"` with your public IP CIDR.
2. Keep keys private:
   - never share the private key file.
3. Do not commit sensitive/local values:
   - commit `terraform.tfvars.example`
   - do not commit `terraform.tfvars`

## Common troubleshooting

### 1) `admin_ssh_key... is not a complete SSH2 Public Key`

Cause: invalid key value or wrong path.

Fix:
- verify `ssh_public_key_path` points to a real `.pub` file
- or set valid full key in `ssh_public_key`

### 2) `SkuNotAvailable`

Cause: VM capacity unavailable in selected region for that size.

Fix:
- change `location`, or
- change `vm_size` to another available SKU, then re-run plan/apply

### 3) Hypervisor generation mismatch (Gen1/Gen2)

Cause: VM size and image generation are incompatible.

Fix:
- keep image/size pairing compatible (this repo is configured for Gen2 currently)

### 4) `resource already exists - needs to be imported`

Cause: resource exists in Azure but not in Terraform state.

Fix:
- import that resource into state, then apply again.

## Validate current state

Check if configuration and Azure resources match:

```bash
terraform plan
```

If output says **No changes**, everything is in sync.

## Destroy (cleanup to avoid cost)

When done:

```bash
terraform destroy
```

Then optionally delete local state files if you no longer need this workspace.

