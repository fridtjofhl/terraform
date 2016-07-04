variable "storageAccountName" {}

resource "azurerm_resource_group" "FridtjofTerraform" {
    name     = "FridtjofTerraform-1"
    location = "North Europe"
	
	tags {
	environment = "TestEnvironment"
	}
}


resource "azurerm_virtual_network" "FridtjofTerraform" {
	name = "vNetwork"
	address_space = ["10.0.0.0/16"]
	location = "North Europe"
	resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
	
}

resource "azurerm_subnet" "FridtjofTerraform"{
    name = "accsub"
    resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
    virtual_network_name = "${azurerm_virtual_network.FridtjofTerraform.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_network_interface" "FridtjofTerraform"{
    name = "acctni"
    location = "North Europe"
    resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.FridtjofTerraform.id}"
        private_ip_address_allocation = "dynamic"
    }
}

module "azure_storage_account" {
    resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
    resource_sa_name = "${var.storageAccountName}"
    source = "./storageacc"
}

resource "azurerm_storage_container" "FridtjofTerraform" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
    storage_account_name = "${var.storageAccountName}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "FridtjofTerraform" {
    name = "acctvm"
    location = "North Europe"
    resource_group_name = "${azurerm_resource_group.FridtjofTerraform.name}"
    network_interface_ids = ["${azurerm_network_interface.FridtjofTerraform.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "14.04.2-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${module.azure_storage_account.primaryBlobEndpoint}${azurerm_storage_container.FridtjofTerraform.name}/myosdisk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }
    os_profile {
        computer_name = "hostname"
        admin_username = "Fridtjofadmin"
        admin_password = "Fridtjof12345!"
    } 
    os_profile_linux_config {
        disable_password_authentication = false        
    }
    tags {
        environment = "staging"
    }
}