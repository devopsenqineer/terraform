provider "hyperv" {
  user     = "Administrator"
  password = var.userpassword
  host     = "10.10.10.10"
  port     = 5986
  https    = true
  insecure = true
  use_ntlm = true
}
