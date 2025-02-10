# bia-terraform

comandos:

terraform init
terraform plan
terraform apply
terraform show
terraform destroy
terraform refresh
terraform output
terraform apply -var 'instance_name=bia_dev_tf-2'
terraform state list
terraform state show aws_security_group.bia_dev
terraform import aws_security_group.bia_dev sg-6a54sadf52165s0df
terraform state rm aws_security_group.bia_dev sg-6a54sadf52165s0df 