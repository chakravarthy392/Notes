terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIA5NFU5LOT6ZVG2KSQ"
  secret_key = "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"
}


resource "aws_instance" "myec2" {
 ami = "ami-0c2b8ca1dad447f8a"
 instance_type = "t2.micro"
 key_name = "permAWS.pem"
 vpc_security_group_ids  = [aws_security_group.allow_sshtf.id]
 provisioner "remote-exec" {
   inline = [
     "sudo amazon-linux-extras install -y nginx1.12",
     "sudo systemctl start nginx"
   ]
 connection {
   type = "ssh"
   user = "ec2-user"
   private_key = file("./permAWS.pem")
   host = self.public_ip
 }
 }
}
resource "aws_security_group" "allow_sshtf" {
  name        = "allow_sshtf"
  description = "Allow SSH inbound traffic"
  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}