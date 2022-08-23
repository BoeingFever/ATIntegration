
#Terraform main config file
#Defining access keys and region
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#Selecting default VPC. In the next block we will attach this VPC to the security groups.
resource "aws_default_vpc" "selected" {

}

resource "aws_security_group" "app_sg" {
  name = "Allow 8080"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #HTTP Port
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSH-HTTP-test"
  }
}


data "aws_ami" "amznlinux" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220719.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "existingkeypair" {
  key_name           = var.key_pair_name
  include_public_key = true
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~>4.1"

  name = "ansible-managed-in"

  ami                    = data.aws_ami.amznlinux.id
  instance_type          = var.server_instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = data.aws_key_pair.existingkeypair.key_name
}

#this is just a test to create local file, no need this resource anymore
resource "local_file" "ip" {
  content  = module.ec2-instance.private_ip
  filename = "instance_ip.txt"
}

resource "null_resource" "execAfterec2created" {

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/${var.key_pair_name}.pem")
    host        = module.ec2-instance.private_ip
  }
  # installing ansible on the provisioned ec2 has nothing to do with the command executing ansible-playbook
  # at the bottom I am executing ansible-playbook locally on my current linux machine to remotely control provisioned ec2
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo amazon-linux-extras install -y ansible2",
    ]
  }

  provisioner "file" {
    source      = "instance_ip.txt"
    destination = "/home/ec2-user/instance_ip.txt"
  }
  provisioner "file" {
    source      = "../ansible/playbook.yml"
    destination = "/home/ec2-user/playbook.yml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${module.ec2-instance.private_ip}, --private-key ../../${var.key_pair_name}.pem ../ansible/playbook.yml"
  }
}
