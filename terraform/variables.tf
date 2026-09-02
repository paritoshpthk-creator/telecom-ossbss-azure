variable "location" {
  description = "Azure region"
  type        = string
  default     = "northcentralus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "telecom"
}

variable "vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_B2as_v2"
}

variable "kubernetes_version" {
  description = "Kubernetes version. Leave null to use the latest supported version."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of AKS system nodes"
  type        = number
  default     = 1
}

variable "acr_sku" {
  description = "Azure Container Registry SKU"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Common Azure resource tags"
  type        = map(string)

  default = {
    project    = "telecom-ossbss"
    managed_by = "terraform"
  }
}