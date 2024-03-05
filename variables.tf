variable "userpassword" {
  description = "Userpassword"
  sensitive   = true
  type        = string
  default     = "Test"
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
  default = {
    type     = "winrm"
    user     = "Administrator"
    password = "Test"
    host     = "11.10.10.10"
    port     = 5986
    https    = true
    insecure = true
    use_ntlm = true
  }
}
