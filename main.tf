terraform {
  required_version = "~> 1.4.0"
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

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "okta" {
  org_name  = "trial-6669138"
  base_url  = "okta.com"
  api_token = var.okta_api_token
}
