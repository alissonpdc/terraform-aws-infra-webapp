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

# Deploy a route table on private subnet "app" pointing to NAT GW (if enabled)
resource "aws_route_table" "route_tables_private_app" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
    if var.enable_nat_gateway == true
  }

  vpc_id = aws_vpc.vpc_app.id
  tags = {
    Name = "${each.key}-route-table"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws_app["public-${split("-", each.key)[2]}"].id
  }
}

# Create an association Route Table x Subnet
resource "aws_route_table_association" "route_table_associations_private" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
    if var.enable_nat_gateway == true
  }

  subnet_id      = aws_subnet.subnets_private_app[each.key].id
  route_table_id = aws_route_table.route_tables_private_app[each.key].id
}