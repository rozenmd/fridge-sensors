resource "aws_iam_role" "iam_api_rest" {
  name = "iam_api_rest_${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy" "iam_api_rest_policy" {
  name = "iam_api_rest_${var.name}_policy"
  role = "${aws_iam_role.iam_api_rest.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3Upload",
      "Resource": "${data.aws_s3_bucket.site_bucket.arn}",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListMultipartUploadParts",
        "s3:ListBucketMultipartUploads",
        "s3:AbortMultipartUpload"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "iam_api_rest_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.api_rest.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${data.aws_s3_bucket.site_bucket.arn}"
}

resource "aws_lambda_function" "api_rest" {
  depends_on = ["aws_s3_bucket_object.api_rest"]
  function_name = "api_rest_${var.name}"
  role          = "${aws_iam_role.iam_api_rest.arn}"
  handler       = "index.handler"
  runtime       = "nodejs8.10"
  timeout       = "30"
  memory_size   = "1536"
  s3_bucket     = "${var.site_url}"
  s3_key        = "lambda/api_rest/index.zip"
  source_code_hash = "${base64sha256(file("../../dist/api_rest/index.zip"))}"

  environment {
    variables = {
      S3_BUCKET = "${var.site_url}"
    }
  }

  tags {
    Site = "${var.name}"
  }
}


resource "aws_lambda_permission" "allow_api_to_exec_lambda" {
  statement_id  = "allow_api_to_exec_lambda"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.api_rest.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.site_api.id}/*/*/*"
}
