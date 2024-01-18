# Deploy private subnets for "app" based on input vars
resource "aws_subnet" "subnets_private_app" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}

# Deploy private subnets for "db" based on input vars
resource "aws_subnet" "subnets_private_db" {
  for_each = {
    for k, v in var.subnets_private_db : k => v
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}