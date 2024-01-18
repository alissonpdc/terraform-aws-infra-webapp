# Deploy an Internet GW on VPC
resource "aws_internet_gateway" "igw_app" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name = "gw-app"
  }
}