variable "resourceGroupName" {}
variable "location" {}
variable "count" {}
variable "name" {}
variable "subnetID" {}

resource "azurerm_network_interface" "nic" {
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    count = "${var.count}"
    name = "${var.name}-${count.index}"
    ip_configuration {
        name = "${var.name}-${count.index}-ipconfig"
        subnet_id = "${var.subnetID}"
        private_ip_address_allocation = "Dynamic"
    }
}

output "idSplat" {
    value = "${join(",", azurerm_network_interface.nic.*.id)}"
}