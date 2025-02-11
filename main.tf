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
  region  = "us-east-1"
  profile = "bia-tf"
}

resource "aws_instance" "bia_dev" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = var.instance_type
  tags = {
    ambiente = "dev"
    Name     = var.instance_name
  }
  vpc_security_group_ids = [aws_security_group.bia_dev.id]
  root_block_device {
    volume_size = 10
  }
  iam_instance_profile = aws_iam_instance_profile.role_acesso_ssm.name
  user_data =  "${file("userdata_bia-dev.sh")}"
}
