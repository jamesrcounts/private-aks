terraform {
  required_version = ">= 0.13"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.32"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }

    azprivatedns = {
      versions = "~> 0.2.5"
      source   = "github.com/jamesrcounts/azprivatedns"
    }
  }

  backend "remote" {
    organization = "jamesrcounts"

    workspaces {
      name = "private-aks"
    }
  }
}

provider azurerm {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = true
    }

    template_deployment {
      delete_nested_items_during_deletion = true
    }

    virtual_machine {
      delete_os_disk_on_deletion = true
    }

    virtual_machine_scale_set {
      roll_instances_when_required = true
    }
  }
}
