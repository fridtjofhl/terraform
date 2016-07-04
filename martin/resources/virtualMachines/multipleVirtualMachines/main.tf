variable "resourceGroupName" {}
variable "location" {}
variable "count" {}
variable "name" {}
variable "size" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "networkInterfaceIDSplat" {}
variable "storageAccountPrimaryBlobEndpoint" {}

resource "azurerm_virtual_machine" "vm" {
    count = "${var.count}"
    name = "${var.name}-${count.index}"
    resource_group_name = "${var.resourceGroupName}"
    location = "${var.location}"
    vm_size = "${var.size}"
    storage_image_reference = {
        publisher = "${var.imagePublisher}"
        offer = "${var.imageOffer}"
        sku = "${var.imageSKU}"
        version = "latest"
    }
    storage_os_disk {
        name = "${var.name}-${count.index}-osdisk"
        vhd_uri = "${var.storageAccountPrimaryBlobEndpoint}vhds/${var.name}-${count.index}-osdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }
    os_profile {
        computer_name = "${var.name}-${count.index}"
        admin_username = "${var.adminUsername}"
        admin_password = "${var.adminPassword}"
    }

    network_interface_ids = ["${element(split(",", var.networkInterfaceIDSplat), count.index)}"]
}
