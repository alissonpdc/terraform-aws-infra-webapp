output "vpc_id" {
  value = aws_vpc.vpc_app.id
}

output "subnet_private_app_ids" {
  value = [for k, v in aws_subnet.subnets_private_app : v.id]
}

output "subnet_private_db_ids" {
  value = [for k, v in aws_subnet.subnets_private_db : v.id]
}

output "subnet_public_ids" {
  value = [for k, v in aws_subnet.subnets_public : v.id]
}