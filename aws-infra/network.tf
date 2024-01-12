resource "aws_vpc" "vpc_app" {
  cidr_block = var.vpc_app_cidr

  tags = {
    Name = "vpc-app"
  }
}

resource "aws_internet_gateway" "gw_app" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name = "gw-app"
  }
}

resource "aws_eip" "eip_ngw_app" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a")) && var.enable_nat_gateway == true
  }

  domain   = "vpc"
  tags = {
    Name = "${each.key}-eip-ngw"
  }
}

resource "aws_nat_gateway" "ngws_app" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a")) && var.enable_nat_gateway == true
  }

  allocation_id = aws_eip.eip_ngw_app[each.key].allocation_id
  subnet_id = aws_subnet.subnets_public[each.key].id
  tags = {
    Name = "${each.key}-ngw"
  }
  depends_on = [
    aws_internet_gateway.gw_app
  ]
}

resource "aws_subnet" "subnets_public" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a"))
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "subnets_private_app" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a"))
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "subnets_private_db" {
  for_each = {
    for k, v in var.subnets_private_db : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a"))
  }

  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_app.id
  tags = {
    Name = "public-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_app.id
  }
}

resource "aws_route_table" "route_tables_private_app" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a")) && var.enable_nat_gateway == true
  }

  vpc_id = aws_vpc.vpc_app.id
  tags = {
    Name = "${each.key}-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws_app["public-${split("-", each.key)[2]}"].id
  }
}

resource "aws_route_table_association" "route_table_associations_public" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a"))
  }

  subnet_id      = aws_subnet.subnets_public[each.key].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_associations_private" {
  for_each = {
    for k, v in var.subnets_private_app : k => v
    if (var.enable_multi_az == true || strcontains("${k}", "1a")) && var.enable_nat_gateway == true
  }

  subnet_id      = aws_subnet.subnets_private_app[each.key].id
  route_table_id = aws_route_table.route_tables_private_app[each.key].id
}