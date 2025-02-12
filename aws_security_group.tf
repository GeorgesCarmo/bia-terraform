resource "aws_security_group" "bia_dev" {
  name        = "bia_dev_tf"
  description = "Security group para instancia de trabalho bia_dev"
  vpc_id      = local.vpc_id
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