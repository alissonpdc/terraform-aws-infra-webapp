resource "aws_s3_bucket" "alissonpdc_terraform_remote_state_bucket" {
  bucket = "alissonpdc-terraform-remote-state-bucket"
  tags   = local.additional_tags
}

resource "aws_s3_bucket_versioning" "bucket_remote_versioning" {
  bucket = aws_s3_bucket.alissonpdc_terraform_remote_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}