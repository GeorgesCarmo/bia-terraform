resource "aws_instance" "bia_dev" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = var.instance_type
  tags = {
    ambiente = "dev"
    Name     = var.instance_name
  }
  subnet_id = local.subnet_zona_a_id
  associate_public_ip_address = true
//  ipv6_address_count = 1
  vpc_security_group_ids = [aws_security_group.bia_dev.id]
  root_block_device {
    volume_size = 10
  }
  iam_instance_profile = aws_iam_instance_profile.role_acesso_ssm.name
  user_data =  "${file("userdata_bia-dev.sh")}"
  key_name = "ec2-key"
}
