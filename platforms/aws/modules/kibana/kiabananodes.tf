resource "aws_instance" "kibana_1" {
    count = "2"
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-west-1b"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${var.sg}"]
    subnet_id = "${var.subnet}"
    source_dest_check = false

    tags {
        Name = "kibana Server ${count.index}"
    }
}

resource "aws_instance" "kibana_2" {
    count = "2"
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-west-1b"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${var.sg}"]
    subnet_id = "${var.subnet}"
    source_dest_check = false

    tags {
        Name = "kibana Server ${count.index}"
    }
}

resource "aws_elb" "kibana" {
  name               = "kibana-terraform-elb"
  
  subnets            = ["${var.subnet}"]



  listener {
    instance_port     = 5601
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:5601/"
    interval            = 30
  }

  instances                   = ["${aws_instance.kibana_1.*.id}","${aws_instance.kibana_2.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "kibana-terraform-elb"
  }
}
output "kibana_network_interface_private_ips" {
  value = ["${aws_instance.kibana_1.*.private_ip}", "${aws_instance.kibana_2.*.private_ip}"]
}