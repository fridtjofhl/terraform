variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}
variable "resourceGroupName" {}
variable "storageAccountName" {}
variable "storageAccountType" {}
variable "virtualNetworkName" {}
variable "virtualNetworkAddressSpace" {}
variable "subnetName" {}
variable "subnetAddressPrefix" {}
variable "VMName" {}
variable "VMSize" {}
variable "imagePublisher" {}
variable "imageOffer" {}
variable "imageSKU" {}
variable "adminUsername" {}
variable "adminPassword" {}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "RG" {
    name = "${var.resourceGroupName}"
    location = "${var.location}"
}

module "storageAccount" {
    source = "../resources/storageAccount"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.storageAccountName}"
    type = "${var.storageAccountType}"
}

module "subnet" {
    source = "../resources/subnet"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    name = "${var.subnetName}"
    virtualNetworkName = "${var.virtualNetworkName}"
    addressPrefix = "${var.subnetAddressPrefix}"
}

module "virtualNetwork" {
    source = "../resources/virtualNetwork"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.virtualNetworkName}"
    addressSpace = "${var.virtualNetworkAddressSpace}"
}

module "privateVMs" {
    source = "../modules/multiplePrivateVMs"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    count = "2"
    name = "${var.VMName}-private"
    subnetID = "${module.subnet.id}"
    size = "${var.VMSize}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
}

module "publicVM" {
    source = "../modules/singlePublicVM"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.VMName}-public"
    size = "${var.VMSize}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
    subnetID = "${module.subnet.id}"
}

output "ipAddress" {
    value = "${module.publicVM.ipAddress}"
}