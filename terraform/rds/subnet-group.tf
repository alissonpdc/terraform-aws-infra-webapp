resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnets_private_ids

  tags = {
    Name = "db-subnet-group"
  }
}