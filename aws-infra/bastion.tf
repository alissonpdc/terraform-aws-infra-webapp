resource "aws_instance" "bastion" {
  count = var.enable_bastion_host == true ? 1 : 0

  ami                    = "ami-0005e0cfe09cc9050"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_bastion[count.index].id]
  # key_name               = aws_key_pair.key_bastion[count.index].key_name
  subnet_id              = aws_subnet.subnets_public["public-1a"].id

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_security_group" "sg_bastion" {
  count       = var.enable_bastion_host == true ? 1 : 0
  name        = "bastion-sg"
  description = "Allow inbound traffic for Bastion Host"
  vpc_id      = aws_vpc.vpc_app.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# resource "aws_key_pair" "key_bastion" {
#   count      = var.enable_bastion_host == true ? 1 : 0
#   key_name   = "bastion-key"
#   public_key = file("./bastion-key-desktop.pub")
# }

resource "aws_eip" "eip_bastion" {
  count    = var.enable_bastion_host == true ? 1 : 0
  instance = aws_instance.bastion[count.index].id
  domain   = "vpc"

  depends_on = [aws_internet_gateway.igw_app]
}