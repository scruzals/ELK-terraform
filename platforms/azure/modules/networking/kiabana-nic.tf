resource "azurerm_network_security_group" "eskibana" {
  name                = "eskibana-nsg"
  location            = "${var.region}"
  resource_group_name = "${var.kibana_resource_group_name}"

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
      source_address_prefix      = "10.0.3.0/24"
      destination_address_prefix = "10.0.3.0/24"
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
    "Role", "kibana"),
    var.extra_tags)}"
}

resource "azurerm_lb" "kibana" {
  name                = "kibanalb"
  location            = "${var.region}"
  resource_group_name = "${var.kibana_resource_group_name}"

  frontend_ip_configuration {
    name                 = "PrivateIPAddress"
    subnet_id            = "/subscriptions/bcbe6459-0d48-4a25-a64f-0056405c1268/resourceGroups/production/providers/Microsoft.Network/virtualNetworks/productionNetwork/subnets/subnet3"
    private_ip_address_allocation = "dynamic"
  }

  tags = "${merge(map(
    "Role", "kibana"),
    var.extra_tags)}"
}

resource "azurerm_lb_backend_address_pool" "kibana" {
  resource_group_name = "${var.kibana_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.kibana.id}"
  name                = "BackEndAddressPool"

}

resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${var.kibana_resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.kibana.id}"
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 5601
  frontend_ip_configuration_name = "PrivateIPAddress"

}

resource "azurerm_lb_probe" "kibana" {
  resource_group_name = "${var.kibana_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.kibana.id}"
  name                = "kibana-running-probe"
  port                = 5601

}


resource "azurerm_network_interface" "elastic_kibana" {
  count                = "2"
  name                 = "esdata${count.index}"
  location            = "${var.region}"
  resource_group_name = "${var.kibana_resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.eskibana.id}"

  ip_configuration {
    name                          = "eskibanaconfig1"
    subnet_id                     = "/subscriptions/bcbe6459-0d48-4a25-a64f-0056405c1268/resourceGroups/production/providers/Microsoft.Network/virtualNetworks/productionNetwork/subnets/subnet3"
    private_ip_address_allocation = "dynamic"
	 load_balancer_backend_address_pools_ids =["${azurerm_lb_backend_address_pool.kibana.id}"]
  }

  tags = "${merge(map(
    "Role", "kibana"),
    var.extra_tags)}"
}
