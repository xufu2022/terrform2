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
rm .terraform* -recurse -force
rm terraform.tfstate*
```

ch3-8

{
    "measureId": 1,
    "lead": "a",
    "unitsOfMeasureId": null,
    "actualClosingPositionStartDate": "2022-06-01T00:00:00",
    "actualClosingPositionStartValue": "sfsdf",
    "actualClosingPositionEndDate": "2022-06-24T00:00:00",
    "actualClosingPositionEndValue": "sdf",
    "actualYtdprevious": "sdf",
    "actualYtdcurrent": "sdf",
    "targetDate": "2022-06-23T00:00:00",
    "targetValue": "sdfsdf",
    "forecastDate": "2022-06-30T00:00:00",
    "forecastValue": "sdfsdf",
    "directionsOfTravelId": 2,
    "statusId": null,
    "createdOn": "2022-06-28T13:59:29.133",
    "createdBy": null,
    "modifiedOn": null,
    "modifiedBy": null,
    "directionsOfTravel": null,
    "measure": null,
    "status": null,
    "unitsOfMeasure": null,
    "id": 1
  }
