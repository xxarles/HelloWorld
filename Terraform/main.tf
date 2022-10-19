
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }

    backend "s3" {
    bucket = "exponently-test-lambda-hello-world-terraform"
    key    = "hello-world/terraform_state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}




module "Lambda"{
  source              = "./HelloWorldLambda"
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
}

