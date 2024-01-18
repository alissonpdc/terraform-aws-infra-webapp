resource "random_integer" "db_identifier" {
  min = 1000000000
  max = 9999999999
}

resource "aws_db_instance" "db_instance" {
  identifier             = "${aws_ssm_parameter.db_name.value}-${random_integer.db_identifier.result}"
  allocated_storage      = 10
  db_name                = aws_ssm_parameter.db_name.value
  engine                 = "postgres"
  instance_class         = var.db_instance_type
  username               = aws_ssm_parameter.db_username.value
  password               = aws_ssm_parameter.db_password.value
  skip_final_snapshot    = true
  apply_immediately      = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  # todo: get az if self-managed nodes
  # availability_zone      = xxx 
}