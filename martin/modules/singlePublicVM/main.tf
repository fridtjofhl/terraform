variable "resourceGroupName" {}
variable "location" {}
variable "name" {}
variable "size" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "storageAccountPrimaryBlobEndpoint" {}
variable "subnetID" {}

module "publicIP" {
    source = "../../resources/dynamicIP"
    resourceGroupName = "${var.resourceGroupName}"
    location = "${var.location}"
    name = "${var.name}-publicIP"
}

module "nic" {
    source = "../../resources/networkInterfaces/singleNetworkInterface"
    resourceGroupName = "${var.resourceGroupName}"
    location = "${var.location}"
    name = "${var.name}-NIC"
    subnetID = "${var.subnetID}"
    publicIPAddressID = "${module.publicIP.id}"
}

module "vm" {
    source = "../../resources/virtualMachines/singleVirtualMachine"
    resourceGroupName = "${var.resourceGroupName}"
    location = "${var.location}"
    name = "${var.name}"
    size = "${var.size}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    networkInterfaceID = "${module.nic.id}"
    storageAccountPrimaryBlobEndpoint = "${var.storageAccountPrimaryBlobEndpoint}"
}

output "networkInterfaceID" {
    value = "module.nic.id"
}

output "ipAddress" {
    value = "${module.publicIP.ipAddress}"
}