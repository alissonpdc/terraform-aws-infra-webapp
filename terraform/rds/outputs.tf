output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "db_address" {
  value = aws_db_instance.db_instance.address
}

output "db_port" {
  value = aws_db_instance.db_instance.port
}

output "db_az" {
  value = aws_db_instance.db_instance.availability_zone
}

output "db_username" {
  value = aws_db_instance.db_instance.username
}

output "db_name" {
  value = aws_db_instance.db_instance.db_name
}