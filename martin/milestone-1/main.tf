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

module "networkInterface" {
    source = "../networkInterfaces/singleNetworkInterface"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.networkInterfaceName}"
    publicIPAddressID = "${module.dynamicIP.id}"
    subnetID = "${module.subnet.id}"
}

module "subnet" {
    source = "../subnet"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    name = "${var.subnetName}"
    virtualNetworkName = "${var.virtualNetworkName}"
    addressPrefix = "${var.subnetAddressPrefix}"

    depends_on = ["module.virtualNetwork"]
}

module "virtualNetwork" {
    source = "../virtualNetwork"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.virtualNetworkName}"
    addressSpace = "${var.virtualNetworkAddressSpace}"
}

module "virtualMachine" {
    source = "../virtualMachines/singleVirtualMachine"
    resourceGroupName = "${azurerm_resource_group.RG.name}"
    location = "${var.location}"
    name = "${var.VMName}"
    size = "${var.VMSize}"
    imagePublisher = "${var.imagePublisher}"
    imageOffer = "${var.imageOffer}"
    imageSKU = "${var.imageSKU}"
    adminUsername = "${var.adminUsername}"
    adminPassword = "${var.adminPassword}"
    networkInterfaceID = "${module.networkInterface.id}"
    storageAccountPrimaryBlobEndpoint = "${module.storageAccount.primaryBlobEndpoint}"
}