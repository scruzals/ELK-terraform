variable "resource_group_name" {
  type = "string"
}
variable "network_interface_ids" {
  type        = "list"
  description = "List of NICs to use for master VMs"
}
variable "region"{
  type = "string"
}

variable "extra_tags" {
  type = "map"
}

variable "vmsize"{
	type = "string"
}

variable "public_ssh_key" {
  type        = "string"
}