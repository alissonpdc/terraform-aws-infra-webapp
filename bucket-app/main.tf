terraform {
  required_version = "~> 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  backend "s3" {
    bucket = "alissonpdc-terraform-remote-state-bucket"
    key    = "terraform-aws-infra-stack/bucket-app/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      managed-by = "terraform"
      repo       = "terraform-aws-infra-stack"
      folder     = "bucket-app"
    }
  }
} 

# Obtem output do state de outro remote state do terraform
# data "terraform_remote_state" "app_bucket_arn" {
#   backend = "s3"
#   config = {
#     bucket = "alissonpdc-terraform-remote-state-bucket"
#     key    = "terraform-aws-infra-stack/bucket-app/terraform.tfstate"
#     region = "us-east-1"
#   }
# }