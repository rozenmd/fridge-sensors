resource "aws_api_gateway_rest_api" "site_api" {
  name        = "${var.name}_api"
  description = "${var.comment}"
}

resource "aws_api_gateway_deployment" "site_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.site_api.id}"
  stage_name  = "prod"
}


resource "aws_api_gateway_resource" "api_rest_endpoint" {
  rest_api_id = "${aws_api_gateway_rest_api.site_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.site_api.root_resource_id}"
  path_part   = "${var.api_rest_endpoint}"
}

resource "aws_api_gateway_method" "api_rest_path_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.site_api.id}"
  resource_id   = "${aws_api_gateway_resource.api_rest_endpoint.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_rest_path_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.site_api.id}"
  resource_id             = "${aws_api_gateway_resource.api_rest_endpoint.id}"
  http_method             = "${aws_api_gateway_method.api_rest_path_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.api_rest.arn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "api_rest_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.site_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.site_api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_rest_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.site_api.id}"
  resource_id             = "${aws_api_gateway_rest_api.site_api.root_resource_id}"
  http_method             = "${aws_api_gateway_method.api_rest_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.api_rest.arn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}
