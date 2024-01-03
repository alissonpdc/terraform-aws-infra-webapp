resource "aws_s3_bucket" "alissonpdc_app_bucket" {
  bucket = "alissonpdc-app-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.alissonpdc_app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}