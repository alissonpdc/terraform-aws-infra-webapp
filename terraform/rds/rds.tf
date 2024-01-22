resource "random_integer" "db_identifier" {
  min = 1000000000
  max = 9999999999
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnets_private_ids

  tags = {
    Name = "db-subnet-group"
  }
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

resource "aws_security_group" "sg_db" {
  name        = "rds-sg"
  description = "Allow inbound traffic for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    security_groups = [var.worker_node_sec_group_id]
    protocol        = "TCP"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}