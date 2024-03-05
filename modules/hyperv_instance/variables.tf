variable "name" {
  description = "Name of the Machine"
  type        = string
}

variable "vhd" {
  description = "Hyper-V VHD"
  type        = string
}

variable "time_synchronization" {
  description = "Disable Integration Services time"
  type        = bool
  default     = false
}

variable "ram" {
  description = "RAM in Bytes"
  type        = string
  default     = "8589934592"
}

variable "processor_count" {
  description = "Processor Count"
  type        = string
  default     = "4"
}

variable "smart_paging_file_path" {
  description = "Smart Paging File Path"
  type        = string
  default     = "C:\\Hyper-V\\Smart Paging File\\"
}

variable "snapshot_file_location" {
  description = "Snapshot File Location"
  type        = string
  default     = "C:\\Hyper-V\\Snapshot File Location\\"
}

variable "switch_name" {
  description = "Network Switch Name"
  type        = string
}

variable "host_password" {
  description = "Userpassword"
  sensitive   = true
  type        = string
  default     = "H0$TP@$$W0RD"
}

variable "vm_password" {
  description = "VM Password"
  sensitive   = true
  type        = string
  default     = "Test"
}

variable "IP" {
  description = "IP of the new machine"
  type        = string
}

variable "MaskBits" {
  description = "Maskbits of the Subnet"
  type        = string
}

variable "Gateway" {
  description = "Default Gateway"
  type        = string
}

variable "NewVMName" {
  description = "Default Gateway"
  type        = string
}

variable "connection" {
  description = "Connection for the provisioner"
  sensitive   = true
  type = object({
    type     = string
    user     = string
    password = string
    host     = string
    port     = number
    https    = bool
    insecure = bool
    use_ntlm = bool
  })
}


