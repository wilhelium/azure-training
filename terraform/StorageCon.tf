provider "azurerm" {
  features {}
}

locals{
   location = "australiaeast"		
}

resource "azurerm_resource_group" "azza" {
  name     = "Azza-group"
  location = local.location 
}

resource "azurerm_storage_account" "azza"{
  name = "azzastorageaccount"
  resource_group_name = azurerm_resource_group.azza.name
  location = local.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "azza" {
  name                  = "azza_contain"
  storage_account_name  = azurerm_storage_account.azza.name
  container_access_type = "private"
}