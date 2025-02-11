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

resource "aws_security_group" "bia_dev" {
  name        = "bia_dev_tf"
  description = "Security group para instancia de trabalho bia_dev"
  vpc_id      = "vpc-056fbd49c146e2d2a"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_3001" {
  description       = "Porta 3001 liberada para o mundo"
  security_group_id = aws_security_group.bia_dev.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3002
  ip_protocol       = "tcp"
  to_port           = 3002
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.bia_dev.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
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
}

resource "aws_iam_policy" "iam_s3_policy" {
  name        = "policy-terraform-tfstate"
  description = "Policy to access s3 bucket"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::bucket-bia-terraform"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::bucket-bia-terraform/terraform.tfstate"
    }
  ]

}
EOT
}
