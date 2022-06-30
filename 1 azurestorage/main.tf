terraform {
    required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.8.0" 
    }       
  }
}

# Provider Block
provider "azurerm" {
 subscription_id="9a50e278-e86c-4db8-ac5f-8c086a445522"     
 tenant_id = "7a2ec892-a4a3-4b1c-bf32-fd77fa210f6b"  
 client_id = "2e3ce0bd-77cc-4e30-984c-905376f1f646"
 client_secret = "q2l8Q~lTy38p_wCn~jOG3qPOrGm2XjuV.1bqwdo7fu"
 features {}
 }

 # Create Resource Group 
resource "azurerm_resource_group" "appgrp" {
  location = "eastus"
  name = "app-grp"  
}

resource "azurerm_storage_account" "appstorefu12345" {
  name                     = "appstorefu12345"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = azurerm_resource_group.appgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
#  account_storage_type="StorageV2"
}



resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appstorefu12345"
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = "appstorefu12345"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
}

# resource "azurerm_storage_blob" "files" {
#   for_each = {
#     "sample1" = "c:\\temp1\\sampl.txt"
#     "sample2" = "c:\\temp1\\samp2.txt"
#     "sample3" = "c:\\temp1\\samp3.txt"
#   }
#   name                   = "${each.key}.txt"
#   storage_account_name   = "appstorefu12345"
#   storage_container_name = "data"
#   type                   = "Block"
#   source                 = each.value
# }

# resource "azurerm_storage_account" "data" {
#   for_each = toset(["data","files","documents"])
#   name                     = each.key
#   resource_group_name      = azurerm_resource_group.appgrp.name
#   location                 = azurerm_resource_group.appgrp.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind = "StorageV2"
# #  account_storage_type="StorageV2"
# }

#resource "azurerm_storage_account" "appstorefu12345" {
#   count = 3
#   name                     = "${count.index}appstorefu12345"
#   resource_group_name      = azurerm_resource_group.appgrp.name
#   location                 = azurerm_resource_group.appgrp.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind = "StorageV2"
# #  account_storage_type="StorageV2"
# }