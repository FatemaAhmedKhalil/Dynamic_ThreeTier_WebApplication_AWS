variable "project_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "vault_token" {
  type      = string
  sensitive = true
}
