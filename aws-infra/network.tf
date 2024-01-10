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
  for_each = aws_subnet.subnets_public
  domain   = "vpc"

  tags = {
    Name = "${each.key}-eip-ngw"
  }
}

resource "aws_nat_gateway" "ngws_app" {
  for_each = aws_subnet.subnets_public
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
  for_each          = var.subnets_public
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "subnets_private_app" {
  for_each          = var.subnets_private_app
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "subnets_private_db" {
  for_each          = var.subnets_private_db
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_app.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table" "route_tables_private_app" {
  for_each = var.subnets_public
  vpc_id = aws_vpc.vpc_app.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws_app[each.key].id
  }

  tags = {
    #todo: fix name using 'public-1a' instead of 'private-1a'
    Name = "${each.key}-route-table"
  }
}
