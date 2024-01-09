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

resource "aws_eip" "eip_ngw" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw_app" {
  for_each = aws_subnet.subnets_private_app
  # allocation_id = aws_eip.example.id
  subnet_id = each.value.id

  tags = {
    Name = "${each.key}-ngw"
  }
  depends_on = [
    aws_internet_gateway.gw_app
  ]
}
resource "aws_nat_gateway" "nat_gw_db" {
  for_each = aws_subnet.subnets_private_db
  # allocation_id = aws_eip.example.id
  subnet_id = each.value.id

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


# resource "aws_route_table" "route_table_private_app" {
#   vpc_id = aws_vpc.vpc_app.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }
# resource "aws_route_table" "route_table_public" {
#   vpc_id = aws_vpc.vpc_app.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }

