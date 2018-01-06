
resource "azurerm_availability_set" "kibana" {
  name                = "kibana"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  managed = "true"

  tags = "${merge(map(
    "Role", "kibana"),
    var.extra_tags)}"
}

resource "azurerm_virtual_machine" "elastic_kibana" {
  
  count                 = "2"
  name                  = "es-kibana-${count.index}"
  location              = "westus"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${var.network_interface_ids[count.index]}"]
  vm_size               = "${var.vmsize}"
  availability_set_id = "${azurerm_availability_set.kibana.id}"


  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "es-kibana-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "es-kibana-datadisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "es-kibana-${count.index}"
    admin_username = "testadmin"
    admin_password = ""
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/testadmin/.ssh/authorized_keys"
      key_data = "${file(var.public_ssh_key)}"
    }
  }

  tags = "${merge(map(
    "Role", "kibana"),
    var.extra_tags)}"
  
}
