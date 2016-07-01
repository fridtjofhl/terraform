resource "azurerm_public_ip" "ip" {
    name = "${var.publicIPAddressName}"
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    public_ip_address_allocation = "Dynamic"
}

output "id" {
    value = "${azurerm_public_ip.ip.id}"
}
