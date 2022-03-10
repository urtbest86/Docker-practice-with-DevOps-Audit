# resorces

//==================================================================
// Resource Group
//==================================================================
resource "azurerm_resource_group" "endalgo_rg" {
  name     = var.endalgo_rg
  location = var.location
}


//==================================================================
// Network
//==================================================================
resource "azurerm_virtual_network" "endalgo_vnet" {
  name                = var.endalgo_vnet
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.endalgo_rg.location
  resource_group_name = azurerm_resource_group.endalgo_rg.name
}

resource "azurerm_subnet" "endalgo_snet_001" {
  name                 = var.endalgo_snet_001
  resource_group_name  = azurerm_resource_group.endalgo_rg.name
  virtual_network_name = azurerm_virtual_network.endalgo_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}


//==================================================================
// WepApp
//==================================================================
resource "azurerm_app_service_plan" "endalgo_plan" {
  name                = var.endalgo_plan
  location            = azurerm_resource_group.endalgo_rg.location
  resource_group_name = azurerm_resource_group.endalgo_rg.name
  // Define Linux as Host OS
  kind     = "Linux"
  reserved = true

  // Choose size
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "endalgo_webapp" {
  name                = var.endalgo_webapp
  location            = azurerm_resource_group.endalgo_rg.location
  resource_group_name = azurerm_resource_group.endalgo_rg.name
  app_service_plan_id = azurerm_app_service_plan.endalgo_plan.id
}


//==================================================================
// Cosmos DB
//==================================================================
resource "azurerm_resource_group" "endalgo_db_rg" {
  name     = var.endalgo_db_rg
  location = var.location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "endalgo_cosmosdb_acc" {
  name                      = var.endalgo_cosmosdb_acc
  location                  = azurerm_resource_group.endalgo_db_rg.location
  resource_group_name       = azurerm_resource_group.endalgo_db_rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  
  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  consistency_policy {
    consistency_level       = "Session"
  }

  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }
  geo_location {
    location          = azurerm_resource_group.endalgo_rg.location
    failover_priority = 0
  }
}