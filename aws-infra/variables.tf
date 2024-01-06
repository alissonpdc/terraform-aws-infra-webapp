variable "ec2_ami" {
  description = "EC2 AMI ID"
  default     = "ami-079db87dc4c10ac91"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.micro"
  type        = string
}

variable "vpc_instances_cidr" {
  description = "VPC for Instances"
  default     = "10.0.0.0/16"
  type        = string
}