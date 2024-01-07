output "alissonpdc_terraform_remote_state_bucket_arn" {
  description = "Terraform Remote State S3 Bucket ARN"
  value       = aws_s3_bucket.alissonpdc_terraform_remote_state_bucket.arn
}

output "alissonpdc_terraform_remote_state_bucket_id" {
  description = "Terraform Remote State S3 Bucket ID"
  value       = aws_s3_bucket.alissonpdc_terraform_remote_state_bucket.id
}