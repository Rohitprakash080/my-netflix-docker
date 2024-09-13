resource "azurerm_resource_group" "rgropra" {
    for_each = var.rg
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "vnetropra" {
    depends_on = [ azurerm_resource_group.rgropra ]
    for_each = var.net
  name                = each.value.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgropra.location
  resource_group_name = azurerm_resource_group.rgropra.name
}

resource "azurerm_subnet" "subnetropra" {
    depends_on = [ azurerm_virtual_network.vnetropra ]
    for_each = var.net
  name                 = each.value.subnetname
  resource_group_name  = azurerm_resource_group.rgropra.name
  virtual_network_name = azurerm_virtual_network.vnetropra.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "pip1" {
    for_each = var.net
  name                = each.value.pipname
  resource_group_name = azurerm_resource_group.rgropra.name
  location            = azurerm_resource_group.rgropra.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nicropra" {
    depends_on = [ azurerm_subnet.subnetropra, azurerm_public_ip.pip1 ]
    for_each = var.net
  name                = each.value.nicname
  location            = azurerm_resource_group.rgropra.location
  resource_group_name = azurerm_resource_group.rgropra.name

  ip_configuration {
    name                          = each.value.ipconfigname
    subnet_id                     = azurerm_subnet.subnetropra.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip1.id
  }
}

resource "azurerm_linux_virtual_machine" "vmropra" {
    depends_on = [ azurerm_network_interface.nicropra ]
    for_each = var.vm
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rgropra.name
  location            = azurerm_resource_group.rgropra.location
  size                = each.value.size
  admin_username      = "adminuser"
  admin_password = "dhodala@0007"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nicropra.id ]
  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = "30"
    name = "1st-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}