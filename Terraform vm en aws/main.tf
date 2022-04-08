provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "ec2-sg" {
  name        = "allow_port_8081"
  description = "Allow inbound traffic port 8081"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "Access port 8081"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = aws_vpc.main.cidr_block
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_port_8081"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name          = "${var.vm-name}"
  ami           = "${var.ami}"
  instance_type = "${var.instance-type}"
  key_name      = "${var.keyname}"
  security_groups = "${aws_security_group.sg_id}"
  }
