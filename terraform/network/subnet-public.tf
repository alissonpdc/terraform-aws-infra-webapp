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

#############################################
###        NAT GATEWAY                     ##
#############################################
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
#############################################


#############################################
###        NAT INSTANCE                    ##
#############################################
resource "aws_instance" "nat_instance" {
  for_each = {
    for k, v in var.subnets_public : k => v
    if var.enable_nat_instance == true
  }

  ami                         = var.nat_instance_ami
  instance_type               = var.nat_instance_type
  subnet_id                   = aws_subnet.subnets_public[each.key].id
  user_data                   = file("./network/files/bootstrap.sh")
  vpc_security_group_ids      = [aws_security_group.sg_nat_instance[0].id]
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "${each.key}-nat-ec2"
  }
}

resource "aws_security_group" "sg_nat_instance" {
  count = var.enable_nat_instance == true ? 1 : 0

  name        = "nat-instance-sg"
  description = "Allow inbound/outbound traffic for NAT Instances"
  vpc_id      = aws_vpc.vpc_app.id

  tags = {
    Name = "nat-instance-sg"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#############################################