resource "aws_vpc" "vpc_instances" {
  cidr_block = var.vpc_instances_cidr

  tags = {
    Name = "instances-vpc"
  }
}

resource "aws_subnet" "subnet_instances_1a" {
  vpc_id            = aws_vpc.vpc_instances.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "network-us-east-1a"
  }
}
resource "aws_subnet" "subnet_instances_1b" {
  vpc_id            = aws_vpc.vpc_instances.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "network-us-east-1b"
  }
}
resource "aws_subnet" "subnet_instances_1c" {
  vpc_id            = aws_vpc.vpc_instances.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "network-us-east-1c"
  }
}