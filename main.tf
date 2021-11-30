# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used

# TODO
# DNS name
# 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


# Create a resource group
resource "azurerm_resource_group" "upskill" {
  name     = "k8sUpskill"
  location = "West Europe"
}

data "azurerm_platform_image" "oracle82" {
  location  = azurerm_resource_group.upskill.location
  publisher = "Oracle"
  offer     = "Oracle-Linux"
  sku       = "ol82-gen2"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "kuvnet" {
  name                = "knodenet"
  resource_group_name = azurerm_resource_group.upskill.name
  location            = azurerm_resource_group.upskill.location
  address_space       = ["10.0.0.0/16"]
}



# V SUB NET

resource "azurerm_subnet" "kusnet" {
  name                 = "knodesub"
  resource_group_name  = azurerm_resource_group.upskill.name
  virtual_network_name = azurerm_virtual_network.kuvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# PUB IP

resource "azurerm_public_ip" "kpub" {
  name                = "kpub"
  resource_group_name = azurerm_resource_group.upskill.name
  location            = azurerm_resource_group.upskill.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "knicpub" {
  name                = "knicpub"
  location            = azurerm_resource_group.upskill.location
  resource_group_name = azurerm_resource_group.upskill.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.kusnet.id
    public_ip_address_id          = azurerm_public_ip.kpub.id
    private_ip_address_allocation = "Dynamic"
  }
}


# NIC0

resource "azurerm_network_interface" "knic0" {
  name                = "knic0"
  location            = azurerm_resource_group.upskill.location
  resource_group_name = azurerm_resource_group.upskill.name
  internal_dns_name_label = "master-cluster-local"
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kusnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#NIC 1

resource "azurerm_network_interface" "knic1" {
  name                = "knic1"
  location            = azurerm_resource_group.upskill.location
  resource_group_name = azurerm_resource_group.upskill.name
  internal_dns_name_label = "node1-cluster-local"
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kusnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#NIC 2

resource "azurerm_network_interface" "knic2" {
  name                = "knic2"
  location            = azurerm_resource_group.upskill.location
  resource_group_name = azurerm_resource_group.upskill.name
  internal_dns_name_label = "node2-cluster-local"
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kusnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "kmaster" {
  name                = "kmaster"
  resource_group_name = azurerm_resource_group.upskill.name
  location            = azurerm_resource_group.upskill.location
  size                = var.vmSize
  admin_username      = var.adminUser

  network_interface_ids = [
    azurerm_network_interface.knicpub.id,
    azurerm_network_interface.knic0.id
  ]

  admin_ssh_key {
    username   = var.adminUser
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.imageid
  
}

## WORKER 1

resource "azurerm_linux_virtual_machine" "knode0" {
  name                = "knode0"
  resource_group_name = azurerm_resource_group.upskill.name
  location            = azurerm_resource_group.upskill.location
  size                = var.vmSize
  admin_username      = var.adminUser

  network_interface_ids = [
    azurerm_network_interface.knic1.id,
  ]

  admin_ssh_key {
    username   = var.adminUser
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.imageid
}




## WORKER 2

resource "azurerm_linux_virtual_machine" "knode1" {
  name                = "knode1"
  resource_group_name = azurerm_resource_group.upskill.name
  location            = azurerm_resource_group.upskill.location
  size                = var.vmSize
  admin_username      = var.adminUser

  network_interface_ids = [
    azurerm_network_interface.knic2.id,
  ]

  admin_ssh_key {
    username   = var.adminUser
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.imageid
}





