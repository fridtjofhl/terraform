resource "azurerm_subnet" "subnet" {
    resource_group_name = "${var.resourceGroupName}"
    name = "${var.name}"
    virtual_network_name = "${var.virtualNetworkName}"
    address_prefix = "${var.addressPrefix}"
}

output "id" {
    value = "${azurerm_subnet.subnet.id}"
}
