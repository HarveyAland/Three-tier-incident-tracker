variable "private_subnet_ids" {
 type = list(string)
}

variable "vpc_id" {}
variable "eks_node_sg_id" {}
variable "name_prefix" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

