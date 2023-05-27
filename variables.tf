variable "s3_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "s3_key" {
  description = "S3 bucket key for Terraform state"
  type        = string
}

variable "s3_region" {
  description = "Region of the S3 bucket for Terraform state"
  type        = string
  default     = "us-east-1"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "okta_api_token" {
  description = "Okta API token"
  type        = string
}


