# TSG Innolab ZTD Terraform

This project contains Terraform code to configure AWS and Okta resources.

## Project Structure

The project is structured as follows:

- `main.tf`: The main Terraform configuration file. This contains the provider configurations for AWS and Okta, and the resource configurations for an Okta user.
- `variables.tf`: This file contains the declaration for variables used in `main.tf`. Sensitive information such as access keys and tokens are passed into `main.tf` as variables.

- `main.tfvars`: This is a local, unversioned file where you should define the variables declared in `variables.tf`. This file should not be committed to your repository.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) should be installed (version 0.13.0 or above)

2. You should have an [AWS account](https://aws.amazon.com/account/) with the necessary permissions.

3. You should have an [Okta account](https://developer.okta.com/signup/) with the necessary permissions.

## How to Use

To use these Terraform scripts, follow these steps:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Acuity-Inc/tsg-innolab-zero-trust-demo-terraform.git
   ```

2. Navigate to the project directory:

   ```bash
   cd ./tsg-innolab-zero-trust-demo-terraform
   ```

3. Create a `main.tfvars` file in the project directory and provide values for all the variables declared in `variables.tf`. Here's an example:

   ```hcl
   aws_access_key = "your_aws_access_key"
   aws_secret_key = "your_aws_secret_key"
   okta_org_name  = "your_okta_org_name"
   okta_base_url  = "okta.com"
   okta_api_token = "your_okta_api_token"
   ```

4. Initialize Terraform:

   ```bash
   terraform init
   ```

5. Validate the configuration:

   ```bash
   terraform validate
   ```

6. Plan the deployment:

   ```bash
   terraform plan -var-file="main.tfvars"
   ```

7. Apply the configuration:

   ```bash
   terraform apply -var-file="main.tfvars"
   ```

   When prompted, enter `yes` to proceed with the creation of resources.
