resource "aws_instance" "data" {
  count                  = "3"
  ami                    = "${lookup(var.amis, var.aws_region)}"
  availability_zone      = "us-west-1a"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  vpc_security_group_ids = ["${var.sg}"]
  subnet_id              = "${var.subnet}"
  source_dest_check      = false

  tags {
    Name = "esdata Server ${count.index}"
  }
}

output "data_network_interface_private_ips" {
  value = ["${aws_instance.data.*.private_ip}"]
}
