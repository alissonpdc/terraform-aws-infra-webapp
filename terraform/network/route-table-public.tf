# Deploy a route table on public subnet pointing to Internet GW
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_app.id
  tags = {
    Name = "public-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_app.id
  }
}

# Create an association Route Table x Subnet
resource "aws_route_table_association" "route_table_associations_public" {
  for_each = {
    for k, v in var.subnets_public : k => v
  }

  subnet_id      = aws_subnet.subnets_public[each.key].id
  route_table_id = aws_route_table.route_table_public.id
}