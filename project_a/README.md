terraform-projecta
===

`projecta` infrastructure managed by Terraform.

## Provisioning Infrastructure
Environments are managed with [Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html).
The `default` workspace is not used.

Run `terraform workspace show` to see the name of the current workspace.

### Production:
1. `terraform workspace select production`
1. `terraform plan -var-file=workspace-variables/production.tfvars`
1. `terraform apply -var-file=workspace-variables/production.tfvars`

### Staging:
1. `terraform workspace select staging`
1. `terraform plan -var-file=workspace-variables/staging.tfvars`
1. `terraform apply -var-file=workspace-variables/staging.tfvars`

## Setup
1. `terraform init`

