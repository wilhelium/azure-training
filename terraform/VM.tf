provider "azurerm" {
  features {}
}

locals {
  location = "australiaeast"
  name = "azzaGroup"	
}

resource "azurerm_resource_group" "azza" {
  name     = local.name
  location = local.location
}

resource "azurerm_virtual_network" "azza" {
  name                = "azzavn"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = local.name
}

resource "azurerm_subnet" "azza" {
  name                 = "myinternal"
  resource_group_name  = local.name
  virtual_network_name = azurerm_virtual_network.azza.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "azza" {
  name                = "azza-nic"
  location            = local.location
  resource_group_name = local.name

  ip_configuration {
    name                          = "ipinternal"
    subnet_id                     = azurerm_subnet.azza.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "azza" {
  name                = "azzamachine"
  resource_group_name = local.name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "azza"
  admin_password      = "P@ssword1234"
  network_interface_ids = [
    azurerm_network_interface.azza.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}