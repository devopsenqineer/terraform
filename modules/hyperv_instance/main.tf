terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "1.2.0"
    }
  }
}

resource "hyperv_machine_instance" "instances" {
  name                       = var.name
  static_memory              = true
  memory_startup_bytes       = var.ram
  generation                 = 2
  processor_count            = var.processor_count
  smart_paging_file_path     = var.smart_paging_file_path
  snapshot_file_location     = var.snapshot_file_location
  state                      = "Running"
  wait_for_ips_poll_period   = 5
  wait_for_ips_timeout       = 300
  wait_for_state_poll_period = 2
  wait_for_state_timeout     = 120

  dvd_drives {
    controller_location = 1
    controller_number   = 0
  }

  vm_processor {
    compatibility_for_migration_enabled               = false
    compatibility_for_older_operating_systems_enabled = false
    enable_host_resource_protection                   = false
    expose_virtualization_extensions                  = false
    hw_thread_count_per_core                          = 1
    maximum                                           = 100
    maximum_count_per_numa_node                       = 32
    maximum_count_per_numa_socket                     = 1
    relative_weight                                   = 100
    reserve                                           = 0
  }

  integration_services = {
    "Guest Service Interface" = false
    "Heartbeat"               = true
    "Key-Value Pair Exchange" = true
    "Shutdown"                = true
    "Time Synchronization"    = var.time_synchronization
    "VSS"                     = true
  }

  network_adaptors {
    name                              = "Network Adapter"
    switch_name                       = var.switch_name
    iov_interrupt_moderation          = "Default"
    iov_weight                        = 0
    allow_teaming                     = "Off"
    packet_direct_moderation_count    = 64
    packet_direct_moderation_interval = 1000000
    vmmq_enabled                      = true
    wait_for_ips                      = false

    hard_disk_drives {
      path                = var.vhd
      controller_number   = 0
      controller_location = 0
      controller_type     = "Scsi" #
    }
    lifecycle {
      ignore_changes = [name]
    }
  }

  resource "terraform_data" "script_copy" {

    provisioner "file" {
      source      = "./modules/hyperv_instance/files"
      destination = "C:/Terraform/"
      connection {
        type     = var.connection.type
        user     = var.connection.user
        password = var.host_password
        host     = var.connection.host
        port     = var.connection.port
        https    = var.connection.https
        insecure = var.connection.insecure
        use_ntlm = var.connection.use_ntlm
      }
    }
    depends_on = [hyperv_machine_instance.instances]
  }

  resource "terraform_data" "script_exec" {

    provisioner "remote-exec" {
      inline = [
        "powershell.exe -ExecutionPolicy Bypass -Command \". C:\\Terraform\\ipconfig.ps1 ; Set-IP -User '${nonsensitive(var.connection.user)}' -Password '${nonsensitive(var.vm_password)}' -VMName '${var.name}' -IP '${var.IP}' -MaskBits '${var.MaskBits}' -Gateway '${var.Gateway}' ; . C:\\Terraform\\changeHostname.ps1 ; Set-Hostname -User '${nonsensitive(var.connection.user)}' -Password '${nonsensitive(var.vm_password)}' -VMName '${var.name}' -NewName '${var.NewVMName}'\""
      ]
      connection {
        type     = var.connection.type
        user     = var.connection.user
        password = var.host_password
        host     = var.connection.host
        port     = var.connection.port
        https    = var.connection.https
        insecure = var.connection.insecure
        use_ntlm = var.connection.use_ntlm
      }
    }
    depends_on = [terraform_data.script_copy]
  }
}

