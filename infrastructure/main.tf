terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>3.0" 
        }
    }
}

provider "azurerm" {
    features {}
}


# Resource Group Creation


resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
}


# Virtual Network


resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name 
}


# AKS Subnet Creation


resource "azurerm_subnet" "aks_subnet" {
    name                 = "aks-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
}


# AKS Deployment


resource "azurerm_kubernetes_cluster" "aks" {
    name                = var.aks_cluster_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix          = var.aks_cluster_name

    default_node_pool {
        name           = "default"
        node_count     = 2
        vm_size        = "Standard_B2s"
        vnet_subnet_id = azurerm_subnet.aks_subnet.id
    }

    identity {
        type = "SystemAssigned"
    }

    network_profile {
        network_plugin     = "azure"
        service_cidr       = "10.0.2.0/24"
        dns_service_ip     = "10.0.2.10"
        docker_bridge_cidr = "172.17.0.1/16"
    }
}