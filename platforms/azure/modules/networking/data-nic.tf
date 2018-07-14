resource "azurerm_network_security_group" "esdata" {
  name                = "esdata-nsg"
  location            = "${var.region}"
  resource_group_name = "${var.data_resource_group_name}"

  security_rule {
    name                       = "elasticsearch"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rdp"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny_all_from_vnet"
    priority                   = 4090
    direction                  = "Inbound"
    access                     = "deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny_all_from_subnet"
    priority                   = 4090
    direction                  = "Outbound"
    access                     = "deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "elasticsearch_out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${merge(map(
    "Role", "data"),
    var.extra_tags)}"
}

resource "azurerm_network_interface" "elastic_data" {
  count                     = "3"
  name                      = "esdata${count.index}"
  location                  = "${var.region}"
  resource_group_name       = "${var.data_resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.esdata.id}"

  ip_configuration {
    name                          = "esdataconfig1"
    subnet_id                     = "/subscriptions/c1549b11-496d-4afd-87ec-d5526336ef5c/resourceGroups/production/providers/Microsoft.Network/virtualNetworks/production-network/subnets/subnet2"
    private_ip_address_allocation = "dynamic"
  }
}
