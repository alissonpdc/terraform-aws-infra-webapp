resource "aws_vpc" "vpc_app" {
  cidr_block = var.vpc_app_cidr

  tags = {
    Name = "vpc-app"
  }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-1a"
  }
}
resource "aws_subnet" "subnet_private_1b" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-1b"
  }
}
resource "aws_subnet" "subnet_private_1c" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-1c"
  }
}