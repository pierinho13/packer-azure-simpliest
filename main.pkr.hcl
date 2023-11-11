packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}

source "azure-arm" "main" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = var.arm_client_id
  client_secret                     = var.arm_cliente_secret
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "West Europe"
  managed_image_name                = "nginx-as-simple-as-possible"
  managed_image_resource_group_name = var.resource_group
  os_type                           = "Linux"
  subscription_id                   = var.arm_suscription_id
  tenant_id                         = var.arm_tenant_id
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.main"]
   provisioner "ansible" {
     playbook_file = "./first_ansible_playbook.yml"
     ansible_env_vars = ["ANSIBLE_CONFIG=./ansible.cfg"]
     extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }
}
