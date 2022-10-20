#Base Configs

variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}


variable "s3_terraform_bucket" {
  description = "Name of the bucket to save the terraform state. Must be setup prior to apply"
  type        = string
  default     = "exponently-lambda-hello-world-terraform"
}

variable "s3_terraform_key" {
  description = "Key to save the terraform state. Must be setup prior to apply"
  type        = string
  default     = "exponently-test-lambda-hello-world-terraform"
}


