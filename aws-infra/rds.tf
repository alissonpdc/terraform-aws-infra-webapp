resource "aws_db_instance" "db_instance" {
  allocated_storage   = 10
  db_name             = "appdb"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  username            = aws_ssm_parameter.db_username.value
  password            = aws_ssm_parameter.db_password.value
  skip_final_snapshot = true
  apply_immediately   = true
  multi_az            = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [ aws_security_group.sg_db.id ]
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/RDS/db_username"
  type  = "String"
  value = "appdb"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/RDS/db_password"
  type  = "SecureString"
  value = "MyDbPassword"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [ for subnet in aws_subnet.subnets_private_db : subnet.id ]

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_security_group" "sg_db" {
  name        = "rds-sg"
  description = "Allow inbound traffic for RDS"
  vpc_id      = aws_vpc.vpc_app.id

  ingress {
    from_port        = 5432
    to_port          = 5432
    security_groups = [ aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id ]
    protocol         = "TCP"
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