pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')    
        TF_VAR_CLOUDFRONT_IP  = "TF_VAR_CLOUDFRONT_IP" 
    }

    stages {
        stage('Build project') {
            steps {
                git 'https://github.com/lav17/Terraform_nodejs_app.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'f69d8b70-3d94-4abe-90c8-9cb608f1a66b', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {     
                    script {
                        sh """
                            terraform init \
                                -var 'AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}' \
                                -var 'AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' \
                                -var 'TF_VAR_CLOUDFRONT_IP=${TF_VAR_CLOUDFRONT_IP}' \
                                -input=false
                        """
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
