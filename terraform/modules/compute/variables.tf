variable "project_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "ami_id" { default = "ami-0c7217cdde317cfec" } 
variable "instance_type" { default = "t2.micro" }
variable "key_name" {}

variable "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  type        = string
}

variable "frontend_sg_id" {
  description = "Security Group ID for Frontend servers"
  type        = string
}

variable "backend_sg_id" {
  description = "Security Group ID for Backend servers"
  type        = string
}

variable "db_sg_id" {
  description = "Security Group ID for Database servers"
  type        = string
}
