variable "prefix" {
  default = "non-prod"
}

variable "region" {
  type        = string
  description = "Region for deployed resources"
  default     = "Sweden Central"
}

variable "main_rg" {
  type        = string
  description = "Main resource-group for this assignment"
  default     = "PublicLB-NATGW-RG"
}

variable "nsg-1" {
  type        = string
  description = "This NSG will be assigned to vm-1"
  default     = "NSG-1"
}

variable "nsg-lb" {
  type        = string
  description = "This NSG will be assigned to vm-1"
  default     = "NSG-LB"
}

variable "main_vnet" {
  type = map(object({
    vnet_name            = string
    vnet_cidr            = string
    backendsubnet_1_name = string
    backendsubnet_1_cidr = string
    subnet_bastion_name  = string
    subnet_bastion_cidr  = string
  }))
  default = {
    vnet1 = {
      vnet_name            = "VNET"
      vnet_cidr            = "20.0.0.0/16"
      backendsubnet_1_name = "BackendSubnet"
      backendsubnet_1_cidr = "20.0.0.0/24"
      subnet_bastion_name  = "AzureBastionSubnet"
      subnet_bastion_cidr  = "20.0.3.0/27"
    }
  }
}

variable "vm_password" {
  type        = string
  description = "Password for VMs"
  sensitive   = true
}
