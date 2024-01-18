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