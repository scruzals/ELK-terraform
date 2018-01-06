variable "aws_region"{
  type = "string"
}
variable "vmsize"{
	type = "string"
}

variable "extra_tags" {
  type = "map"
}

variable "aws_key_name" {
  type        = "string"
}

variable "amis" {
    type = "map"
}

variable "sg"{
	
}

variable subnet {
	
}