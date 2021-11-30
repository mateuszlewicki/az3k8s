
variable "client_secret"{
  type = string
  sensitive   = true
}

variable "client_id"{
  type = string
  sensitive   = true
}
variable "subscription_id"{
  type = string
  sensitive   = true

}
variable "tenant_id"{
  type = string
  sensitive   = true

}


variable "adminUser" {
  type = string
  default = "p-k8s-adm"
}

variable "vmSize" {
  type = string
  default = "Standard_F2s_v2"
}
