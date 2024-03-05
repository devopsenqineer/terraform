terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "1.2.0"
    }
  }
  backend "local" {
    path = "/home/user/tf_state/terraform.tfstate"
  }
}

locals {
  path_base_vhd = "C:\\Hyper-V\\Virtual Machines\\Contoso-#REPLACE#\\Virtual Hard Disks\\WindowsServer2022.vhdx"
}

data "hyperv_vhd" "vhd_1" {

  path = replace(local.path_base_vhd, "#REPLACE#", "Machine01")
}

data "hyperv_vhd" "vhd_2" {
  path = replace(local.path_base_vhd, "#REPLACE#", "Machine02")
}

data "hyperv_vhd" "vhd_3" {
  path = replace(local.path_base_vhd, "#REPLACE#", "Machine03")
}

data "hyperv_vhd" "vhd_4" {
  path = replace(local.path_base_vhd, "#REPLACE#", "Machine04")
}

data "hyperv_vhd" "vhd_5" {
  path = replace(local.path_base_vhd, "#REPLACE#", "Machine05")
}

data "hyperv_vhd" "vhd_6" {
  path = replace(local.path_base_vhd, "#REPLACE#", "Machine06")
}

resource "hyperv_network_switch" "this" {
  name                                    = "vswitch01"
  default_flow_minimum_bandwidth_absolute = 100000000
  default_queue_vmmq_enabled              = true
  default_queue_vrss_enabled              = true
  minimum_bandwidth_mode                  = "Absolute"
  net_adapter_names                       = ["Port Name"]
  switch_type                             = "External"
}


module "contoso-machine-01" {
  connection      = var.connection
  source          = "./modules/hyperv_instance"
  name            = "Contoso"
  NewVMName       = "Contoso-Machine01"
  vhd             = data.hyperv_vhd.vhd_1.path
  switch_name     = hyperv_network_switch.this.name
  IP              = "10.10.10.10"
  Gateway         = "10.10.10.01"
  MaskBits        = "25"
  processor_count = "10"
}

module "contoso-machine-02" {
  connection           = var.connection
  source               = "./modules/hyperv_instance"
  name                 = "Contoso"
  NewVMName            = "Contoso-Machine02"
  vhd                  = data.hyperv_vhd.vhd_1.path
  switch_name          = hyperv_network_switch.this.name
  IP                   = "11.10.10.10"
  Gateway              = "10.10.10.01"
  MaskBits             = "25"
  processor_count      = "10"
  time_synchronization = false
}

module "contoso-machine-03" {
  connection  = var.connection
  source      = "./modules/hyperv_instance"
  name        = "Contoso"
  NewVMName   = "Contoso-Machine03"
  vhd         = data.hyperv_vhd.vhd_3.path
  switch_name = hyperv_network_switch.this.name
  IP          = "12.10.10.10"
  Gateway     = "10.10.10.01"
  MaskBits    = "25"
  ram         = "6442450944"
}

module "contoso-machine-04" {
  connection  = var.connection
  source      = "./modules/hyperv_instance"
  name        = "Contoso"
  NewVMName   = "Contoso-Machine04"
  vhd         = data.hyperv_vhd.vhd_4.path
  switch_name = hyperv_network_switch.this.name
  IP          = "13.10.10.10"
  Gateway     = "10.10.10.01"
  MaskBits    = "25"
}

module "contoso-machine-05" {
  connection      = var.connection
  source          = "./modules/hyperv_instance"
  name            = "Contoso"
  NewVMName       = "Contoso-Machine05"
  vhd             = data.hyperv_vhd.vhd_5.path
  switch_name     = hyperv_network_switch.this.name
  IP              = "14.10.10.10"
  Gateway         = "10.10.10.01"
  MaskBits        = "25"
  processor_count = 6
}

module "contoso-machine-06" {
  connection      = var.connection
  source          = "./modules/hyperv_instance"
  name            = "Contoso"
  NewVMName       = "Contoso-Machine06"
  vhd             = data.hyperv_vhd.vhd_6.path
  switch_name     = hyperv_network_switch.this.name
  IP              = "15.10.10.10"
  Gateway         = "10.10.10.01"
  MaskBits        = "25"
  ram             = "6442450944"
  processor_count = "2"
}
