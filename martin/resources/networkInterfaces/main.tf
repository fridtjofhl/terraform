variable "resourceGroupName" {}
variable "location" {}
variable "count" {
  default = "1"
}
variable "name" {}
variable "subnetID" {}
variable "publicIPAddressID" {
  default = ""
}

resource "azurerm_network_interface" "nic" {
  resource_group_name = "${var.resourceGroupName}"
  location = "${var.location}"
  count = "${var.count}"
  name = "${var.name}-${count.index}"
  ip_configuration {
    name = "${var.name}-${count.index}-ipconfig"
    subnet_id = "${var.subnetID}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${var.publicIPAddressID}"
  }
}

output "idSplat" {
  value = "${join(",", azurerm_network_interface.nic.*.id)}"
}
