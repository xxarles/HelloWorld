resource "aws_lambda_function" "base" {
  function_name = "${var.project_name}"

  package_type = "Image"
  image_uri = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.project_name}:latest"
  
  role = "${aws_iam_role.lambda_role.arn}"
  environment {
    variables = {
      ENV = "dev"
    }
  }
  depends_on = [aws_ecr_repository.lambda]

}



resource "aws_lambda_permission" "image_upload_dev_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.base.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*"
}




resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_base_policy.json}"
}


resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.project_name}_lambda_policy"
  role   = "${aws_iam_role.lambda_role.id}"
  policy = "${data.aws_iam_policy_document.lambda_policy.json}"
}

data "aws_iam_policy_document" "lambda_policy" {

  statement {
    effect = "Allow"

    actions = [
      "lambda-object:*",
      "lambda:*",
      "logs:*",
      "s3:*",
      "SNS:*",
      "dynamodb:*",
    ]

    resources = ["*"]

  }

}


