terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.61.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet" {
  name     = var.kube_resource_group_name
  location = var.location
}

module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = ["10.0.0.0/16"]
  subnets = [
    {
      name : "jumpboxsubnet"
      address_prefixes : ["10.0.0.0/22"]
    },
    {
      name : "akssubnet"
      address_prefixes : ["10.0.4.0/22"]
    }
  ]
}

data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = var.kube_version_prefix
}

resource "azurerm_kubernetes_cluster" "privateaks" {
  name                    = "privateaks"
  location                = var.location
  kubernetes_version      = data.azurerm_kubernetes_service_versions.current.latest_version
  resource_group_name     = azurerm_resource_group.vnet.name
  dns_prefix              = "privateaks"
  private_cluster_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = var.nodepool_nodes_count
    vm_size        = var.nodepool_vm_size
    vnet_subnet_id = module.kube_network.subnet_ids["akssubnet"]
  }

  identity {
    type = "SystemAssigned"
  }

 network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = "azure"
    service_cidr       = var.network_service_cidr
  }
}

resource "azurerm_role_assignment" "netcontributor" {
  role_definition_name = "Network Contributor"
  scope                = module.kube_network.subnet_ids["akssubnet"]
  principal_id         = azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
}

module "jumpbox" {
  source                  = "./modules/jumpbox"
  location                = var.location
  resource_group          = azurerm_resource_group.vnet.name
  vnet_id                 = module.kube_network.vnet_id
  subnet_id               = module.kube_network.subnet_ids["jumpboxsubnet"]
  dns_zone_name           = join(".", slice(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn))))
  dns_zone_resource_group = azurerm_kubernetes_cluster.privateaks.node_resource_group
}