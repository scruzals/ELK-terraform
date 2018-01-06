# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}
module "resource_group" {
  source = "./modules/resource_group"
  region = "${var.region}"
  extra_tags = "${var.extra_tags}"
  
}

module "networking" {
  source = "./modules/networking"
  master_resource_group_name = "${module.resource_group.master_rg_name}"
  data_resource_group_name = "${module.resource_group.data_rg_name}"
  kibana_resource_group_name = "${module.resource_group.kibana_rg_name}"
  region = "${var.region}"
  extra_tags = "${var.extra_tags}"
  
}

module "master" {
  source = "./modules/master"
  resource_group_name = "${module.resource_group.master_rg_name}"
  network_interface_ids   = "${module.networking.master_network_interface_ids}" 
  region = "${var.region}"
  vmsize = "${var.esmaster_vm_size}"
  extra_tags = "${var.extra_tags}"
  public_ssh_key = "${var.azure_ssh_key}"
}

module "data" {
  source = "./modules/data"
  resource_group_name = "${module.resource_group.data_rg_name}"
  network_interface_ids   = "${module.networking.data_network_interface_ids}"
  region = "${var.region}"
  vmsize = "${var.esdata_vm_size}"
  extra_tags = "${var.extra_tags}"
  public_ssh_key = "${var.azure_ssh_key}"
}

module "kibana" {
  source = "./modules/kibana"
  resource_group_name = "${module.resource_group.kibana_rg_name}"
  network_interface_ids   = "${module.networking.kibana_network_interface_ids}"
  region = "${var.region}"
  extra_tags = "${var.extra_tags}"
  vmsize = "${var.eskibana_vm_size}"
  extra_tags = "${var.extra_tags}"
  public_ssh_key = "${var.azure_ssh_key}"
}

output "master_network_interface_private_ips" {
  value = ["${module.networking.master_network_interface_private_ips}"]
}

output "data_network_interface_private_ips" {
  value = ["${module.networking.data_network_interface_private_ips}"]
}

output "kibana_network_interface_private_ips" {
  value = ["${module.networking.kibana_network_interface_private_ips}"]
}