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

variable "instance_names" {
  type = list
  default = ["Dev instance", "QA instance", "Prod instance" ]
}

resource "aws_instance" "instance-1" {
  ami = "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t2.micro"
  count = 3
  tags = {
    Name = var.instance_names[count.index]
  }
}
