# Introduction
This is the repo with all the infrastructure for the image clustering project

One should be able to run this simply by doing, but that's not how life works
```terraform init```
```terraform apply```



# List of resources
- ECR registry for image 
- s3 buckets for images and artifacts
- ImageUpload lambda and api_gateway
- SNS for file uploaded
- DynamoDB for processing status
- Cognito user poll
- API gateway with cognito authorization (failing for unknown reasons - one should destroy ASAP to avoid problems)
- Modularized deploy
- To have google OAuth, please setup and google client and the env variables:
    - TF_VAR_OAUTH_CLIENT_ID
    - TF_VAR_OAUTH_CLIENT_SECRET
