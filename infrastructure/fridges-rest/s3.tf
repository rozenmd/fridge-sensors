output "S3_BUCKET" {
  value = "${data.aws_s3_bucket.site_bucket.id}"
}

data "aws_s3_bucket" "site_bucket" {
  bucket = "${var.site_url}"

}

resource "aws_s3_bucket_object" "api_rest" {
  bucket = "${data.aws_s3_bucket.site_bucket.id}"
  key    = "lambda/api_rest/index.zip"
  source = "../../dist/api_rest/index.zip"
  etag   = "${md5(file("../../dist/api_rest/index.zip"))}"
}
