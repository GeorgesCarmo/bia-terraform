variable "instance_name" {
  description = "Nome da instância"
  type = string
  default = "bia_dev_tf"
}

variable "instance_type" {
  description = "Tipo da instância"
  type = string
  default = "t3.micro"
}