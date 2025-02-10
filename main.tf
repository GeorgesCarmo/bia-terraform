terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "bia-tf"
}

resource "aws_instance" "bia_dev" {
  ami = "ami-02f3f602d23f1659d"
  instance_type = "t3.micro"
  tags = {
    ambiente = "dev"
    Name = "bia_dev"
  }
}