terraform {
  backend "remote" {
    organization = "endalgo"

    workspaces {
      name = "endalgo-prd"
    }
  }
}

provider "azurerm" {
  version = "~>2.0"

  features {}
}