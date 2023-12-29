# Terraform Node Application Cloudfront

1. Create a new pipeline on jenkins.
2. Select "Pipeline script from SCM".
3. Mentiona the Github repository and path to Jenkinsfile.
4. Save & Apply
5. Click on build now.

Note : create the credentials in Jenkins by installing AWS Credential plugin and name it is as AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. Create a secret text for variable TF_VAR_CLOUDFRONT_IP and mention the Prefix list id of Cludfront IP's.
