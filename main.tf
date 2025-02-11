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
  description       = "Porta 8080 liberada para o mundo"
  security_group_id = aws_security_group.bia_dev.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
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
  iam_instance_profile = aws_iam_instance_profile.role_acesso_ssm.name
  user_data =  <<EOF
#!/bin/bash

#Instalar Docker e Git
sudo yum update -y
sudo yum install git -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker ssm-user
id ec2-user ssm-user
sudo newgrp docker

#Ativar docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Instalar docker compose 2
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


#Adicionar swap
sudo dd if=/dev/zero of=/swapfile bs=128M count=32
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab


#Instalar node e npm
curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
sudo yum install -y nodejs
EOF
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
