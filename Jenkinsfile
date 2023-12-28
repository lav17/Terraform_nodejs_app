pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')    
        TF_VAR_CLOUDFRONT_IP       = "TF_VAR_CLOUDFRONT_IP" 
    }

    stages {
        stage('Build project') {
            steps {
                git url : "https://github.com/lav17/Terraform_nodejs_app.git" , branch : "master"
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init -input=false' 
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
