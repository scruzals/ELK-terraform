resource "azurerm_resource_group" "ELK_cluster_master" {
  location = "${var.region}"
  name     = "ELK_cluster_masters"
  tags = "${merge(map(
    "Role", "master"),
    var.extra_tags)}"
}
resource "azurerm_resource_group" "ELK_cluster_data" {
  location = "${var.region}"
  name     = "ELK_cluster_data"
  tags = "${merge(map(
    "Role", "data"),
    var.extra_tags)}"
}
resource "azurerm_resource_group" "ELK_cluster_kibana" {
  location = "${var.region}"
  name     = "ELK_cluster_kibana"
  tags = "${merge(map(
    "Role", "kibana"),
    var.extra_tags)}"
}

output "kibana_rg_name" {
  value = "${azurerm_resource_group.ELK_cluster_kibana.name}"
} 
output "master_rg_name" {
  value = "${azurerm_resource_group.ELK_cluster_master.name}"
}
output "data_rg_name" {
  value = "${azurerm_resource_group.ELK_cluster_data.name}"
}
