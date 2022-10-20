# Introduction

This repo creates and example labda function and the necessary infrastructure to deploy a container.

All the infrastructure is created using terraform. The code is in the Main docker Folder.

# Requirements

* Aws account with AWS cli setup 
* Docker installed

# Setup

first create the infrastructure

* Since the s3 bucket name is unique globally, that needs to be set in Terrafor/main.tf to store the state safely
* First run ```terraform init``` in the folder Terraform/HelloWorld to initialize the module
* Then run ```terraform init``` in Terraform folder
* Finally run ```terraform apply```

After the infrastructure is up 

* Change folder to MainDocker and in Linux run ```./build.sh```
* Select option p and hit return
* This builds a new container, uploads to ecr and updates the lambda

To check if everything works fine:

* Get the url with terraform output base_url
* Get the api-key with terraform output api_key

# Testing

Run without api-key with:
```
    curl --request POST \
    --url <URL> \
    --data '{}'
```

and it shoud receive a forbidden message. Runnig the one below sould receive a "Hello World!"

```
    curl --request POST \
    --url <URL> \
    --header 'x-api-key: <key>' \
    --data '{}'
```