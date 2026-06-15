terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

data "vault_generic_secret" "aws_creds" {
  path = "secret/aws/creds"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_generic_secret.aws_creds.data["access_key"]
  secret_key = data.vault_generic_secret.aws_creds.data["secret_key"]
  token      = data.vault_generic_secret.aws_creds.data["session_token"]
}  

provider "vault" {
  address         = "https://127.0.0.1:8200"
  token           = var.vault_token
  skip_tls_verify = true
}
