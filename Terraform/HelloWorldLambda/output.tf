
output "url"{
    value = aws_api_gateway_deployment.lambda.invoke_url
}

output "key"{
    value = aws_api_gateway_api_key.api_key.value
}