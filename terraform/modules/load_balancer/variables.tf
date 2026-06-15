variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ext_alb_sg_id" {
  type = string
}

variable "int_alb_sg_id" {
  type = string
}
