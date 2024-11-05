terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2d706a5b-cc0f-44ce-89c4-15e95472db17"
}