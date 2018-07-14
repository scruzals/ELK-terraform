provider "aws" {
  region = "${var.region}"
}

module "networking" {
  source                = "./modules/networking"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnet_cidr    = "${var.public_subnet_cidr}"
  private_subnet_cidr   = "${var.private_subnet_cidr}"
  private_subnet_2_cidr = "${var.private_subnet_2_cidr}"
  public_subnet_2_cidr  = "${var.public_subnet_2_cidr}"
  aws_region            = "${var.region}"
  extra_tags            = "${var.extra_tags}"
  aws_key_name          = "${var.aws_key_name}"
}

module "master" {
  source       = "./modules/master"
  aws_region   = "${var.region}"
  vmsize       = "${var.esmaster_vm_size}"
  extra_tags   = "${var.extra_tags}"
  aws_key_name = "${var.aws_key_name}"
  amis         = "${var.amis}"
  sg           = "${module.networking.sg_db}"
  subnet       = "${module.networking.subnet-pri-1b}"
}

module "data" {
  source       = "./modules/data"
  aws_region   = "${var.region}"
  vmsize       = "${var.esdata_vm_size}"
  extra_tags   = "${var.extra_tags}"
  aws_key_name = "${var.aws_key_name}"
  amis         = "${var.amis}"
  sg           = "${module.networking.sg_db}"
  subnet       = "${module.networking.subnet-pri-1b}"
}

module "kibana" {
  source       = "./modules/kibana"
  aws_region   = "${var.region}"
  extra_tags   = "${var.extra_tags}"
  vmsize       = "${var.eskibana_vm_size}"
  extra_tags   = "${var.extra_tags}"
  aws_key_name = "${var.aws_key_name}"
  amis         = "${var.amis}"
  sg           = "${module.networking.sg_db}"
  subnet       = "${module.networking.subnet-pri-1b}"
}

output "master_network_interface_private_ips" {
  value = ["${module.master.master_network_interface_private_ips}"]
}

output "data_network_interface_private_ips" {
  value = ["${module.data.data_network_interface_private_ips}"]
}

output "kibana_network_interface_private_ips" {
  value = ["${module.kibana.kibana_network_interface_private_ips}"]
}
