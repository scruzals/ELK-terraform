variable "vpc_cidr" {
}

variable "public_subnet_cidr" {
}

variable "private_subnet_cidr" {
}

variable "private_subnet_2_cidr" {
}

variable "public_subnet_2_cidr" {
}

variable "extra_tags" {
  type = "map"

}

variable "aws_region"{
  type = "string"
}

variable "aws_key_name" {
  type        = "string"
}