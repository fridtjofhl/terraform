variable "resourceGroupName" {}
variable "location" {}
variable "name" {}
variable "subnetID" {}
variable "publicIPAddressID" {}

resource "azurerm_network_interface" "nic" {
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    name = "${var.name}"
    ip_configuration {
        name = "${var.name}-ipconfig"
        subnet_id = "${var.subnetID}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = "${var.publicIPAddressID}"
    }
}

output "id" {
    value = "${azurerm_network_interface.nic.id}"
}