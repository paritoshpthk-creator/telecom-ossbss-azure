terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ============================================================
# 1. Resource Group
# ============================================================

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-ossbss-${var.environment}"
  location = var.location

  tags = var.tags
}

# ============================================================
# 2. Virtual Network
# ============================================================

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  address_space = [
    "10.10.0.0/16"
  ]

  tags = var.tags
}

# ============================================================
# 3. AKS Subnet
# ============================================================

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [
    "10.10.1.0/24"
  ]
}

# ============================================================
# 4. PostgreSQL Subnet
# ============================================================

resource "azurerm_subnet" "postgres" {
  name                 = "snet-postgres"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [
    "10.10.2.0/24"
  ]

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# ============================================================
# 5. Secondary 5G Network Subnet
# ============================================================

resource "azurerm_subnet" "five_g" {
  name                 = "snet-5g-secondary"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [
    "10.10.10.0/24"
  ]
}

# ============================================================
# 6. Log Analytics Workspace
# ============================================================

resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

# ============================================================
# 7. Azure Container Registry
# ============================================================

resource "azurerm_container_registry" "main" {
  name                = "acrtelecomossbss01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku           = var.acr_sku
  admin_enabled = true

  tags = var.tags
}

# ============================================================
# 8. AKS Cluster
# ============================================================

resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  dns_prefix = "aks-${var.project_name}-${var.environment}"

  kubernetes_version = var.kubernetes_version

  # ----------------------------------------------------------
  # System Node Pool
  # ----------------------------------------------------------
  #
  # IMPORTANT:
  # Standard_B2as_v2:
  #   vCPU = 2
  #   RAM  = 8 GB
  #
  # North Central US quota:
  #   Regional vCPU = 4
  #
  # Therefore node_count = 1 is intentionally used.
  #
  # Availability Zones are NOT configured because:
  # Standard_B2as_v2 has no zones available in this region.
  #
  # ----------------------------------------------------------

  default_node_pool {
    name = "system"

    node_count = var.node_count
    vm_size    = var.vm_size

    vnet_subnet_id = azurerm_subnet.aks.id

    type = "VirtualMachineScaleSets"
  }

  # ----------------------------------------------------------
  # Managed Identity
  # ----------------------------------------------------------

  identity {
    type = "SystemAssigned"
  }

  # ----------------------------------------------------------
  # Monitoring
  # ----------------------------------------------------------

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # ----------------------------------------------------------
  # Network
  # ----------------------------------------------------------

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}

# ============================================================
# 9. AKS -> ACR Pull Permission
# ============================================================

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope = azurerm_container_registry.main.id

  role_definition_name = "AcrPull"

  principal_id = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

