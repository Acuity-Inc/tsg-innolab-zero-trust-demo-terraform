terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    okta = {
      source  = "oktadeveloper/okta"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = var.s3_bucket
    key    = var.s3_key
    region = var.s3_region
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

resource "okta_user" "example" {
  first_name = var.okta_user_first_name
  last_name  = var.okta_user_last_name
  login      = var.okta_user_login
  email      = var.okta_user_email
}
