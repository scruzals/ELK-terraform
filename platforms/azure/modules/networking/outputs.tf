output "master_network_interface_ids" {
  value = ["${azurerm_network_interface.elastic_master.*.id}"]
}
output "data_network_interface_ids" {
  value = ["${azurerm_network_interface.elastic_data.*.id}"]
}

output "kibana_network_interface_ids" {
  value = ["${azurerm_network_interface.elastic_kibana.*.id}"]
}

output "master_network_interface_private_ips" {
  value = ["${azurerm_network_interface.elastic_master.*.private_ip_address}"]
}

output "data_network_interface_private_ips" {
  value = ["${azurerm_network_interface.elastic_data.*.private_ip_address}"]
}

output "kibana_network_interface_private_ips" {
  value = ["${azurerm_network_interface.elastic_kibana.*.private_ip_address}"]
}