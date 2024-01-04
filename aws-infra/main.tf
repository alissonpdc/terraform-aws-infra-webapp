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
    key    = "terraform-aws-infra-stack/aws-infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      managed-by = "terraform"
      repo       = "terraform-aws-infra-stack"
      folder     = "aws-infra"
    }
  }
}