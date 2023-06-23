terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = var.s3_bucket
    key    = var.s3_key
    region = var.aws_region
    
  }
}

provider "aws" {
  region = var.aws_region
}

provider "okta" {
  org_name  = "demo-zero-trust-prototype"
  base_url  = "okta.com"
  api_token = var.okta_api_token
  
}

resource "okta_user_type" "agency_employee" {
  name = "AgencyEmployee"
  display_name = "Agency Employee"
  description = "Agency Employee"
}

resource "okta_user_schema_property" "highest_security_clearance" {
  type = "string"
  index = "highestSecurityClearance"
  title = "Highest Security Clearance"
  description = "Highest Security Clearance"
  user_type = okta_user_type.agency_employee.id
  required = true
  enum = ["none", "publictrust", "ts", "poly"]

  one_of {
      const = "none"
      title = "None"
  }

  one_of {
      const = "publictrust"
      title = "Public Trust"
  }

  one_of {
      const = "ts"
      title = "Top Secret"
  }

  one_of {
    const = "poly"
    title = "TS/Poly"
  }
}

resource "okta_user_schema_property" "can_make_decisions" {
  type = "boolean"
  index = "canMakeDecisions"
  title = "Can Make Decisions?"
  user_type = okta_user_type.agency_employee.id
  required = true
}

resource "okta_user_schema_property" "can_search" {
  type = "boolean"
  index = "canSearch"
  title = "Can Search?"
  user_type = okta_user_type.agency_employee.id
  required = true
}

resource "okta_user_schema_property" "can_search_app" {
  type = "boolean"
  index = "canSearch"
  title = "Can Search?"
}

resource "okta_user" "test-user-1" {
  user_type          = "AgencyEmployee"
  first_name         = "Test"
  last_name          = "User 1"
  login              = "zerotrustprototype001@myacuity.com"
  email              = "zerotrustprototype001@myacuity.com"
  # custom_profile_attributes = jsonencode({
  #   canSearch = false
  #   canMakeDecisions = false
  #   highestSecurityClearance = "publictrust"
  # })
}

resource "okta_user" "test-user-2" {
  user_type          = "AgencyEmployee"
  first_name         = "Test"
  last_name          = "User 2"
  login              = "zerotrustprototype002@myacuity.com"
  email              = "zerotrustprototype002@myacuity.com"
  # custom_profile_attributes = jsonencode({
  #   canSearch = true
  #   canMakeDecisions = true
  #   highestSecurityClearance = "poly"
  # })
}

resource "okta_user" "test-user-3" {
  user_type          = "AgencyEmployee"
  first_name         = "Test"
  last_name          = "User 3"
  login              = "zerotrustprototype003@myacuity.com"
  email              = "zerotrustprototype003@myacuity.com"
  # custom_profile_attributes = jsonencode({
  #   canSearch = true
  #   canMakeDecisions = false
  #   highestSecurityClearance = "ts"
  # })
}

resource "okta_user" "test-user-4" {
  user_type          = "AgencyEmployee"
  first_name         = "Test"
  last_name          = "User 4"
  login              = "zerotrustprototype004@myacuity.com"
  email              = "zerotrustprototype004@myacuity.com"
  # custom_profile_attributes = jsonencode({
  #   canSearch = false
  #   canMakeDecisions = true
  #   highestSecurityClearance = "ts"
  # })

}

resource "okta_user" "test-user-5" {
  user_type          = "AgencyEmployee"
  first_name         = "Test"
  last_name          = "User 5"
  login              = "zerotrustprototype005@myacuity.com"
  email              = "zerotrustprototype005@myacuity.com"
  # custom_profile_attributes = jsonencode({
  #   canSearch = true
  #   canMakeDecisions = true
  #   highestSecurityClearance = "publictrust"
  # })
}

/*
resource "okta_app_oauth" "zerotrustdemo-app" {
  label          = "zerotrustdemo"
  type           = "browser"
  grant_types    = ["authorization_code"]
  implicit_assignment  = true
  redirect_uris  = ["http://localhost:3000/login/callback"]
}


resource "okta_profile_mapping" "user-claims-mappings" {
  source_id          = okta_user_type.agency_employee.id
  target_id          = okta_app_oauth.zerotrustdemo-app.id
  delete_when_absent = true

  mappings {
    id         = "formatted"
    expression = "user.highestSecurityClearance"
  }

  mappings {
    id         = "canSearch"
    expression = "user.canSearch"
  }

  mappings {
    id         = "canMakeDecisions"
    expression = "user.canMakeDecisions"
  }
}
*/
