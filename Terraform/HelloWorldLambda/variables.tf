#################################################################
############################BASE DEFS############################
#################################################################


variable "project_name" {
  description = "The project name"
  type        = string
  default     = "hello_world"
}

variable "account_id"{
  description = "Account Id used to terraform"
  type        = string
}

variable "region"{
  description = "Account default region used to terraform"
  type        = string
}


#################################################################
############################ ECR ################################
#################################################################

variable "ecr_mutability"{
  description = "ECR tag mutability config"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_policy"{
  description = "Image upload ECR tag mutability config"
  type        = string
  default     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

variable "ecr_force_delete" {
    description = "Ecr force delete from terraform destroy" 
    type        = string
    default     = true
}

data "aws_iam_policy_document" "lambda_base_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}


#################################################################
####################### API GATEWAY ################################
#################################################################

variable key_name{
  description = "Name of the api key"
  type = string
  default = "hello_world_key"
}

variable key_description{
  description = "Description of the api key"
  type = string
  default = "This is the key that should be used to call the lambda"
}