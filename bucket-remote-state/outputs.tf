output "alissonpdc_terraform_remote_state_bucket_arn" {
  description = "S3 Terraform Remote State Bucket ARN"
  value       = aws_s3_bucket.alissonpdc_terraform_remote_state_bucket.arn
}

output "alissonpdc_terraform_remote_state_bucket_id" {
  description = "S3 Terraform Remote State Bucket ID"
  value       = aws_s3_bucket.alissonpdc_terraform_remote_state_bucket.id
}