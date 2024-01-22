# Deploy public subnets based on input vars
resource "aws_subnet" "subnets_public" {
  for_each = {
    for k, v in var.subnets_public : k => v
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}

# Deploy a Nat GW on each public subnet (if enabled)
resource "aws_nat_gateway" "ngws_app" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if var.enable_nat_gateway == true
  }

  allocation_id = aws_eip.eip_ngw_app[each.key].allocation_id
  subnet_id     = aws_subnet.subnets_public[each.key].id
  tags = {
    Name = "${each.key}-ngw"
  }
}

# Deploy an Elastic IP to attach to NAT GW (if enabled)
resource "aws_eip" "eip_ngw_app" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if var.enable_nat_gateway == true
  }

  domain = "vpc"
  tags = {
    Name = "${each.key}-eip-ngw"
  }
}

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