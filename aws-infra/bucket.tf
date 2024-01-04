# resource "aws_s3_bucket" "alissonpdc_aws_bucket" {
#   bucket = "alissonpdc-test-remote-state-bucket"
#   tags = {
#     # Obtem valor de variavel pela precedencia: terraform.auto.tfvars > terraform.tfvars > variables.tf default
#     custom-tag = var.custom-tag
#     # Obtem ARN do bucket a partir do arquivo de state remoto do "bucket-app"
#     app-bucket = data.terraform_remote_state.app_bucket_arn.outputs.alissonpdc_app_bucket_arn
#   }
# #   # Obtem tags atraves do arquivo de reutilizacao do locals.tf
# #   # tags = local.additional_tags
# }

# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = resource.aws_s3_bucket.alissonpdc_aws_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }