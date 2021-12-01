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
}
variable "tenant_id"{
  type = string
  sensitive   = true
}

variable "imageName" {
  type = string
  default = "orapacker"
}

variable "miresgrp"{
  type = string
  default = "packerrg"
}
variable "vmSize" {
  type = string
  default = "Standard_F2s_v2"
}


source "azure-arm" "oracle82" {
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"

  managed_image_name = "${var.imageName}"
  managed_image_resource_group_name = "${var.miresgrp}"

  os_type = "Linux"
  image_publisher = "Oracle"
  image_offer = "Oracle-Linux"
  image_sku = "ol82-gen2"

  azure_tags = {
    purpouse = "k8s"
  }

  location = "West Europe"
  vm_size = "${var.vmSize}"
}

build {
  sources = ["sources.azure-arm.oracle82"]
  provisioner "shell" {
    script = "nopass.sh"
  }

  provisioner "ansible" {
    playbook_file = "./configVMs.yml"
    galaxy_file = "./requirements.yml"
    user = "packer"

    }

}
