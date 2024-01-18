resource "random_password" "db_password" {
  length  = 8
  special = false
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/RDS/db_username"
  type  = "String"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/RDS/db_password"
  type  = "SecureString"
  value = random_password.db_password.result
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/RDS/db_endpoint"
  type  = "String"
  value = aws_db_instance.db_instance.endpoint
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/RDS/db_name"
  type  = "String"
  value = var.db_name
}