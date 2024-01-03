output "alissonpdc_app_bucket_arn" {
  description = "S3 App Bucket ARN"
  value       = aws_s3_bucket.alissonpdc_app_bucket.arn
}

output "alissonpdc_app_bucket_id" {
  description = "S3 App Bucket ID"
  value       = aws_s3_bucket.alissonpdc_app_bucket.id
}