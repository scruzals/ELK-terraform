variable "region" {
  default = "centralus"
}

variable "master_count" {
  default = "3"
}

variable "esmaster_vm_size" {
  default = "Standard_DS1_V2"
}

variable "esdata_vm_size" {
  default = "Standard_DS1_V2"
}

variable "eskibana_vm_size" {
  default = "Standard_DS1_V2"
}

variable "extra_tags" {
  type = "map"

  description = <<EOF
(optional) A map of extra Azure tags to be applied to created resources.
NOTE: Tags MUST NOT contain reserved characters '<,>,%,&,\,?,/' or control characters.
EOF

  default = {
    Environment = "Production"
    Platform    = "ELK"
    AppID       = "1234"
  }
}

variable "azure_ssh_key" {
  type        = "string"
  description = "(required) Path to an SSH public key file to be provisioned as the SSH key for the 'testadmin' user."
  default     = "../../resources/id_rsa.pub"
}
