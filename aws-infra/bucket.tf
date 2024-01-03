# resource "aws_s3_bucket" "alissonpdc_aws_bucket" {
#   bucket = "alissonpdc-aws-bucket"
#   # tags = {
#   #   custom-tag = var.custom-tag
#   # }
#   tags = local.additional_tags
# }

# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = aws_s3_bucket.alissonpdc_aws_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }