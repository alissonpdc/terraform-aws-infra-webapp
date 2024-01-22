# Deploy a new VPC
resource "aws_vpc" "vpc_app" {
  cidr_block = var.vpc_app_cidr

  tags = {
    Name = "vpc-app"
  }
}

# Deploy an Internet GW on VPC
resource "aws_internet_gateway" "igw_app" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name = "gw-app"
  }
}