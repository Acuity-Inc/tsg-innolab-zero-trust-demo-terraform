import groovy.json.JsonSlurper

node {
    stage('Checkout Code') {
      scm_vars = checkout scm
      env.GIT_COMMIT = scm_vars.GIT_COMMIT
      env.GIT_PREVIOUS_SUCCESSFUL_COMMIT = scm_vars.GIT_PREVIOUS_SUCCESSFUL_COMMIT
    }
    
    stage('Retrieve Environment Variables') {
        try {
            def ssmParameterNames = [
                '/ztd/terraform/aws_s3_bucket',
                '/ztd/terraform/aws_s3_key',
                '/ztd/terraform/aws_s3_region',
                '/ztd/terraform/aws_region',
                '/ztd/terraform/okta_authorization_header',
                '/ztd/terraform/okta_base_url',
                '/ztd/terraform/okta_client_id',
                '/ztd/terraform/okta_client_secret',
                '/ztd/terraform/okta_api_token',


            ]

            def ssmCommand = 'aws ssm get-parameters --names ' +
                    "${ssmParameterNames.join(' ')} " +
                    '--with-decryption --output json'

            def ssmOutput = sh(script: ssmCommand, returnStdout: true).trim()
            echo(ssmOutput)
            def ssmJson = new JsonSlurper().parseText(ssmOutput)

            // Assign the retrieved values to Jenkins environment variables
            ssmParameterNames.each { parameterName ->
                def parameterValue = ssmJson.Parameters.find { it.Name == parameterName }?.Value ?: ''
                // Remove '/ztd/terraform/' prefix and convert to uppercase
                def envVariableName = parameterName.replace('/ztd/terraform/', '').toUpperCase()
                env."${envVariableName}" = parameterValue
                // Log the value of '/ztd/terraform/aws_region'
                echo "The value of ${envVariableName} is: ${parameterValue}"
            }
        } catch (Exception e) {
            echo "Error occurred while retrieving environment variables: ${e.message}"
        }
    }
    

    stage('Create Docker Container') {
        try {
            def containerName = 'terraform_container'
            def existingContainerId = sh(script: "docker ps -aq -f name=${containerName}", returnStdout: true)

            if (existingContainerId) {
                echo "Container with name ${containerName} already exists with ID ${existingContainerId}"
                env.TERRAFORM_CONTAINER_ID = existingContainerId
                sh "docker logs ${existingContainerId}"
            } else {
                echo "Container with name ${containerName} does not exist. Creating it..."

                def dockerRunCommand = """
                    docker run -d \
                    -e AWS_S3_BUCKET=${env.AWS_S3_BUCKET} \
                    -e AWS_S3_KEY=${env.AWS_S3_KEY} \
                    -e AWS_S3_REGION=${env.AWS_S3_REGION} \
                    -e AWS_REGION=${env.AWS_REGION} \
                    -e OKTA_API_TOKEN=${env.OKTA_API_TOKEN} \
                    --name ${containerName} \
                    --entrypoint "/bin/sh" \
                    -v "${env.WORKSPACE}:/terraform" \
                    hashicorp/terraform:1.4.0 \
                    -c "cd terraform && sleep infinity"
                """

                // Run the Docker container and get the container ID
                def containerId = sh(script: dockerRunCommand, returnStdout: true).trim()
                sh "docker logs ${containerId}"
                echo "Started Docker container with ID: ${containerId}"
                // Check the status of the Docker container
                sh 'docker ps -a'

                // Save the container ID for later stages
                env.TERRAFORM_CONTAINER_ID = containerId
            }
        } catch (Exception e) {
            echo "Error occurred while creating Docker container: ${e.message}"
        }
    }

    stage('Terraform Init') {
        sh 'docker ps -a'
        echo(env.TERRAFORM_CONTAINER_ID)
        try {
            // Define the Docker exec command
            def dockerExecCommand = """
                docker exec ${env.TERRAFORM_CONTAINER_ID} \
                sh -c "cd terraform && terraform init -backend-config='bucket=${env.AWS_S3_BUCKET}' -backend-config='key=${env.AWS_S3_KEY}' -backend-config='region=${env.AWS_S3_REGION}'"
            """

            // Execute the command in the Docker container
            sh(script: dockerExecCommand)
        } catch (Exception e) {
            echo "Error occurred while running Terraform init: ${e.message}"
        }
    }

    stage('Terraform Plan') {
        try {
            // Define the Docker exec command
            def dockerExecCommand = """
                docker exec ${env.TERRAFORM_CONTAINER_ID} \
                sh -c "cd terraform && ls && terraform plan -var 'aws_region=${env.AWS_REGION}' -var 's3_bucket=${env.AWS_S3_BUCKET}' -var 's3_key=${env.AWS_S3_KEY}' -var 's3_region=${env.AWS_S3_REGION}' -var 'okta_api_token=${env.OKTA_API_TOKEN}' -out=tfplan"
            """

            // Execute the command in the Docker container
            sh(script: dockerExecCommand)
        } catch (Exception e) {
            echo "OKTA_API_TOKEN=${env.OKTA_API_TOKEN}"
            echo "Error occurred while running Terraform plan: ${e.message}"
        }
    }

    stage('Terraform Apply') {
        try {
            // Define the Docker exec command
            def dockerExecCommand = """
                docker exec ${env.TERRAFORM_CONTAINER_ID} \
                sh -c "cd terraform && terraform apply -auto-approve tfplan"
            """

            // Execute the command in the Docker container
            sh(script: dockerExecCommand)
        } catch (Exception e) {
            echo "Error occurred while running Terraform apply: ${e.message}"
        }
    }

    stage('Clean Up Docker Container') {
        try {
            // If container is not null
            if (env.TERRAFORM_CONTAINER_ID) {
                // Stop the Docker container
                sh(script: "docker stop ${env.TERRAFORM_CONTAINER_ID}")
                // Remove the Docker container
                sh(script: "docker rm ${env.TERRAFORM_CONTAINER_ID}")
            }
        } catch (Exception cleanupException) {
            echo "Failed to cleanup Docker container: ${cleanupException.message}"
        }
    }
}
