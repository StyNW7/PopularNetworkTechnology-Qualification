variable "resource_group_name" {
    type        = string
    description = "The name of the Azure Resource Group"
    default     = "linkasa-rg"
}

variable "location" {
    type        = string
    description = "The Azure region where the resource will be created"
    default     = "southeastasia"
}

variable "vnet_name" {
    type        = string
    description = "The name for the AKS cluster"
    default     = "linkasa-aks-cluster"
}

variable "aks_cluster_name" {
    type        = string
    description = "The name for the AKS cluster."
    default     = "linkasa-aks-cluster"
}