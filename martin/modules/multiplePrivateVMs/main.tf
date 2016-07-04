variable "resourceGroupName" {}
variable "location" {}
variable "count" {}
variable "name" {}
variable "subnetID" {}
variable "size" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}
variable "storageAccountPrimaryBlobEndpoint" {}

module "privateVirtualMachines" {
    source = "../../resources/virtualMachines/multipleVirtualMachines"
    resourceGroupName = "${var.resourceGroupName}"
    location = "${var.location}"
    count = "${var.count}"
    name = "${var.name}"
    size = "${var.size}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    networkInterfaceIDSplat = "${module.privateNetworkInterfaces.idSplat}"
    storageAccountPrimaryBlobEndpoint = "${var.storageAccountPrimaryBlobEndpoint}"
}

module "privateNetworkInterfaces" {
    source = "../../resources/networkInterfaces/multipleNetworkInterfaces"
    resourceGroupName = "${var.resourceGroupName}"
    location = "${var.location}"
    count = "${var.count}"
    name = "${var.name}-NIC"
    subnetID = "${var.subnetID}"
}