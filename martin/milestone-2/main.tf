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
    source = "../storageAccount"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.storageAccountName}"
    type = "${var.storageAccountType}"
}

module "dynamicIP" {
    source = "../dynamicIP"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.publicIPAddressName}"
}

module "subnet" {
    source = "../subnet"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    name = "${var.subnetName}"
    virtualNetworkName = "${var.virtualNetworkName}"
    addressPrefix = "${var.subnetAddressPrefix}"
}

module "virtualNetwork" {
    source = "../virtualNetwork"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.virtualNetworkName}"
    addressSpace = "${var.virtualNetworkAddressSpace}"
}

module "privateNetworkInterfaces" {
    source = "../networkInterfaces/multipleNetworkInterfaces"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    count = "3"
    name = "${var.networkInterfaceName}"
    subnetID = "${module.subnet.id}"
}

module "privateVirtualMachines" {
    source = "../virtualMachines/multipleVirtualMachines"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    count = "3"
    name = "${var.VMName}"
    size = "${var.VMSize}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    networkInterfaceIDSplat = "${module.privateNetworkInterfaces.idSplat}"
    storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
}