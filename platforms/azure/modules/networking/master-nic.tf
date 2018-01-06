resource "azurerm_network_security_group" "esmaster" {
  name                = "esmaster-nsg"
  location            = "${var.region}"
  resource_group_name = "${var.master_resource_group_name}"

  security_rule {
    name                       = "test123"
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
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "10.0.1.0/24"
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
    "Role", "master"),
    var.extra_tags)}"
}


resource "azurerm_network_interface" "elastic_master" {
  count                = "3"
  name                 = "esmaster${count.index}"
  location            = "${var.region}"
  resource_group_name = "${var.master_resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.esmaster.id}"

  ip_configuration {
    name                          = "esmaster1config"
    subnet_id                     = "/subscriptions/bcbe6459-0d48-4a25-a64f-0056405c1268/resourceGroups/production/providers/Microsoft.Network/virtualNetworks/productionNetwork/subnets/subnet1"
    private_ip_address_allocation = "dynamic"
  }
}
