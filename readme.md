# terraform tutorial

## Azure AD

## Step-01: Terraform Core Commands
```t
# Terraform Initialize
terraform init
terraform init --upgrade

# Terraform Validate
terraform validate

# Terraform Plan to Verify what it is going to create / update / destroy
terraform plan

terraform plan -out main.tfplan

# Terraform Apply to Create Resources
terraform apply -auto-approve
```
## Verify Azure Resource Group in Azure Management Console
- Review `terraform.tfstate` file 

## Step-05: Destroy Infrastructure
terraform destroy

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```