resource "azurerm_virtual_machine" "vm" {
    name = "${var.name}"
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
        name = "${var.name}_osdisk"
        vhd_uri = "${var.storageAccountPrimaryBlobEndpoint}vhds/${var.name}_osdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }
    os_profile {
        computer_name = "${var.name}"
        admin_username = "${var.adminUsername}"
        admin_password = "${var.adminPassword}"
    }

    network_interface_ids = ["${var.networkInterfaceID}"]
}
