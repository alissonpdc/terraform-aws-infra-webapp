resource "aws_launch_template" "ec2_launch_template" {
  name                   = "ec2-template"
  image_id               = var.ec2_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [
    aws_security_group.sg_instances.id
  ]
}

resource "aws_autoscaling_group" "ec2_asg" {
  name             = "instances-asg"
  max_size         = 3
  min_size         = 2
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.subnet_private_1a.id,
    aws_subnet.subnet_private_1b.id,
    aws_subnet.subnet_private_1c.id
  ]
  launch_template {
    id = aws_launch_template.ec2_launch_template.id
  }
}