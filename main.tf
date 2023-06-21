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
  org_name  = "trial-6669138"
  base_url  = "okta.com"
  api_token = var.okta_api_token
  
}

resource "okta_user_type" "agency_employee2" {
  name = "AgencyEmployee2"
  display_name = "Agency Employee 2"
  description = "Agency Employee2"

  
}

resource "okta_user_schema_property" "highest_security_clearance" {
  type = "string"
  index = "highestSecurityClearance"
  title = "Highest Security Clearance"
  description = "Highest Security Clearance"
  user_type = okta_user_type.agency_employee2.id
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
  user_type = okta_user_type.agency_employee2.id
  required = true
}

resource "okta_user_schema_property" "can_search" {
  type = "boolean"
  index = "canSearch"
  title = "Can Search?"
  user_type = okta_user_type.agency_employee2.id
  required = true
}

resource "okta_user" "user1" {
  user_type          = "AgencyEmployee2"
  first_name         = "John"
  last_name          = "Smith"
  login              = "john.smith@example.com"
  email              = "john.smith@example.com"
  city               = "New York"
  cost_center        = "10"
  country_code       = "US"
  department         = "IT"
  display_name       = "Dr. John Smith"
  division           = "Acquisitions"
  employee_number    = "111111"
  honorific_prefix   = "Dr."
  honorific_suffix   = "Jr."
  locale             = "en_US"
  manager            = "Jimbo"
  manager_id         = "222222"
  middle_name        = "John"
  mobile_phone       = "1112223333"
  nick_name          = "Johnny"
  organization       = "Testing Inc."
  postal_address     = "1234 Testing St."
  preferred_language = "en-us"
  primary_phone      = "4445556666"
  profile_url        = "https://www.example.com/profile"
  second_email       = "john.smith.fun@example.com"
  state              = "NY"
  street_address     = "5678 Testing Ave."
  timezone           = "America/New_York"
  title              = "Director"
  zip_code           = "11111"
  custom_profile_attributes = jsonencode({
    canSearch = false
    canMakeDecisions = false
    highestSecurityClearance = "ts"
  })
}

resource "okta_user" "user2" {
  first_name         = "Adam"
  last_name          = "Bones"
  login              = "adam.bones@example.com"
  email              = "adam.bones@example.com"
  city               = "Los Angeles"
  cost_center        = "2"
  country_code       = "US"
  department         = "IT"
  display_name       = "Adam Bones"
  division           = "Acquisitions"
  employee_number    = "111211"
  locale             = "en_US"
  manager            = "Jimbo"
  manager_id         = "222222"
  middle_name        = "John"
  mobile_phone       = "1112223333"
  nick_name          = "wow"
  organization       = "Testing Inc."
  postal_address     = "1234 Testing St."
  preferred_language = "en-us"
  primary_phone      = "4445556666"
  profile_url        = "https://www.example.com/profile"
  second_email       = "john.smith.fun@example.com"
  state              = "NY"
  street_address     = "5678 Testing Ave."
  timezone           = "America/New_York"
  title              = "Director"
  user_type          = "Employee"
  zip_code           = "11111"
}

resource "okta_app_oauth" "zerotrustdemo-app" {
  label          = "zerotrustdemo"
  type           = "browser"
  grant_types    = ["authorization_code"]
  implicit_assignment  = true
  redirect_uris  = ["http://localhost:3000/login/callback"]
}

/*
data "okta_user_profile_mapping_source" "user" {}

resource "okta_profile_mapping" "user-claims-mappings" {
  source_id          = okta_user_type.agency_employee2.id
  target_id          = "${data.okta_user_profile_mapping_source.user.id}"
  delete_when_absent = true

  mappings {
    id         = "highestSecurityClearance"
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


/* Applications*/
resource "okta_app_oauth" "nola_test"{
  label = "nola-test-2"
  type = "browser"
  grant_types = ["authorization_code"]
  redirect_uris = ["http://localhost:3000/login/callback"]
  pkce_required = true
  consent_method = "REQUIRED"
  post_logout_redirect_uris = ["http://localhost:3000/"]
  
  
  // Federation Broker Mode
  implicit_assignment = true
  

  

  


}