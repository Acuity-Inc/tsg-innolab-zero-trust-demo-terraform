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

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "okta_org_name" {
  description = "Okta organization name"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
}

variable "okta_user_first_name" {
  description = "First name for the Okta user"
  type        = string
}

variable "okta_user_last_name" {
  description = "Last name for the Okta user"
  type        = string
}

variable "okta_user_login" {
  description = "Login for the Okta user"
  type        = string
}

variable "okta_user_email" {
  description = "Email for the Okta user"
  type        = string
}
