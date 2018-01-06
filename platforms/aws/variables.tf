variable "aws_access_key" {
	
}
variable "aws_secret_key" {
	
}

variable "region"{
	default="us-west-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "12.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "12.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "12.0.1.0/24"
}

variable "private_subnet_2_cidr" {
    description = "CIDR for the 2nd Private Subnet"
    default = "12.0.2.0/24"
}

variable "public_subnet_2_cidr" {
    description = "CIDR for the 2nd Public Subnet"
    default = "12.0.3.0/24"
}

variable "master_count"{
	default = "3"
}

variable "esmaster_vm_size"{
	default = "t2.micro"
}

variable "esdata_vm_size"{
	default = "t2.micro"
}

variable "eskibana_vm_size"{
	default = "t2.micro"
}

variable "extra_tags" {
  type = "map"

  description = <<EOF
(optional) A map of extra Azure tags to be applied to created resources.
NOTE: Tags MUST NOT contain reserved characters '<,>,%,&,\,?,/' or control characters.
EOF

  default = {
	Environment = "Production"
	Platform = "ELK"
	AppID = "1234"  
  }
}

variable "aws_key_name" {
  type        = "string"
  description = "(required) Path to an SSH public key file to be provisioned as the SSH key for the instance user."
  default = "terraform"
}

variable "amis" {
    type = "map"
    description = "AMIs by region"
    default = {
        us-west-1 = "ami-45ead225" # ubuntu 14.04 LTS
    }
}
variable "sg" {
  default=""
}
