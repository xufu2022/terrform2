terraform {
    required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.10.0" 
    }       
  }
}

# Provider Block
provider "azurerm" {
 subscription_id="9a50e278-e86c-4db8-ac5f-8c086a445522"     
 tenant_id = "7a2ec892-a4a3-4b1c-bf32-fd77fa210f6b"  
 client_id = "2e3ce0bd-77cc-4e30-984c-905376f1f646"
 client_secret = "q2l8Q~lTy38p_wCn~jOG3qPOrGm2XjuV.1bqwdo7"
 features {}
 }

locals {
  resoure_group_name="app-grp"
  location="eastus"
  virtual_network_name="app-network"
  subnets=[
    {
      name="subnetA"
      location="10.0.0.0/24"
    },    
    {
      name="subnetB"
      location="10.0.1.0/24"
    }
  ]
  }
  

 # Create Resource Group 
resource "azurerm_resource_group" "appgrp" {
  location = local.location
  name = local.resoure_group_name  
}

# Create Virtual Network
resource "azurerm_virtual_network" "appnetwork" {
  name                = local.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.appgrp.location
  resource_group_name = azurerm_resource_group.appgrp.name
}

# Create Subnet
resource "azurerm_subnet" "subnetA" {
  name                 = local.subnets[0].name
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.appnetwork.name
  address_prefixes     = [local.subnets[0].location]
}

resource "azurerm_subnet" "subnetB" {
  name                 = local.subnets[1].name
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.appnetwork.name
  address_prefixes     = [local.subnets[1].location]
}

# Create Network Interface
resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = local.location
  resource_group_name = local.resoure_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     =tolist(azurerm_virtual_network.appnetwork.subnet)[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id 
  }
  depends_on = [
    azurerm_virtual_network.appnetwork
  ]
}

# Create Public IP Address
resource "azurerm_public_ip" "appip" {
  # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created. 
  depends_on = [
    azurerm_resource_group.appgrp
  ]
  name                = "appip"
  resource_group_name = local.resoure_group_name
  location            = local.location
  allocation_method   = "Static"

}

# output "subnetA-id" {
#   value=azurerm_virtual_network.appnetwork.subnet
# }

# Resource: Create Network Security Group

resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resoure_group_name

  security_rule {
    name                       = "AllowRGP"  
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}

resource "azurerm_windows_virtual_machine" "appvm" {
  name                = "appvm"
  resource_group_name = local.resoure_group_name
  location            = local.location
  size                = "Standard_D2S_V3"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.appinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.appinterface,
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_managed_disk" "appdisk" {
  name                 = "appdisk"
  location             = local.location
  resource_group_name  = local.resoure_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

resource "azurerm_virtual_machine_data_disk_attachment" "appdiskattach" {
  managed_disk_id    = azurerm_managed_disk.appdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.appvm.id
  lun                = "10"
  caching            = "ReadWrite"
}