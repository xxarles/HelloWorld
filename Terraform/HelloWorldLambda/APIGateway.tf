
resource "aws_api_gateway_rest_api" "gateway" {
  name        = "${var.project_name}_gateway"
  description = "Base gateway to ${var.project_name}"

  #endpoint_configuration {
  #  types            = ["PRIVATE"]
  #}
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true

}


resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.base.invoke_arn}"
}


resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
  # authorizer_id = aws_api_gateway_authorizer.upload_lambda_api_authorizer.id
  # authorization_scopes = var.cognito_scope_identifiers
  api_key_required = true


}


resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.base.invoke_arn}"
}

resource "aws_api_gateway_deployment" "lambda" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
    aws_api_gateway_api_key.api_key,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  stage_name  = "entry"
}

resource "aws_api_gateway_stage" "lambda" {
  deployment_id = aws_api_gateway_deployment.lambda.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  stage_name    = "base"
}


resource "aws_api_gateway_usage_plan" "usage_plan" {
  name         = "Base usage plan"
  description  = ""

  api_stages {
    api_id = aws_api_gateway_rest_api.gateway.id
    stage  = aws_api_gateway_stage.lambda.stage_name
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.gateway.id
    stage  = aws_api_gateway_deployment.lambda.stage_name
  }
  

  quota_settings {
    limit  = 150
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}


resource "aws_api_gateway_api_key" "api_key" {
    name = "${var.key_name}"
    description = "${var.key_description}"
    enabled = true
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
    key_id        = "${aws_api_gateway_api_key.api_key.id}"
    key_type      = "API_KEY"
    usage_plan_id = "${aws_api_gateway_usage_plan.usage_plan.id}"
}