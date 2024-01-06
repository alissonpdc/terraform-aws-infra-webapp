resource "aws_security_group" "instances_sg" {
  name        = "instances-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc_instances.id

  ingress {
    description      = "Public SSH"
    from_port = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "instances-sg"
  }
}

resource "aws_key_pair" "key" {
  key_name   = "ec2-key"
  public_key = file("./ec2-key.pub")
}


resource "aws_instance" "instance_a" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = resource.aws_key_pair.key.key_name
  vpc_security_group_ids = [resource.aws_security_group.instances_sg.id]

  tags = {
    Name = "Instance_A"
  }

  provisioner "local-exec" {
    command = "echo \"${self.arn}\" >> ${self.tags["Name"]}.txt"
  }
  provisioner "local-exec" {
    command = "echo \"${self.public_ip}\" >> ${self.tags["Name"]}.txt"
  }

  connection {
    type     = "ssh"
    user     = "ec-user"
    host = self.public_ip
    private_key = resource.aws_key_pair.key.public_key
  }

}

