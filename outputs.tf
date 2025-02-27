output "instance_id" {
  description = "ID da EC2"
  value       = aws_instance.bia_dev.id
}

output "instance_type" {
  description = "Tipo da EC2"
  value       = aws_instance.bia_dev.instance_type
}

output "instance_security_group" {
  description = "Security group da EC2"
  value       = aws_instance.bia_dev.security_groups
}

output "instance_public_ip" {
  description = "IP público da EC2"
  value       = aws_instance.bia_dev.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint da BIA"
  value       = aws_db_instance.bia.endpoint
}

output "rds_secret" {
  description = "Secret do RDS da BIA"
  value = tolist(aws_db_instance.bia.master_user_secret)[0].secret_arn
}