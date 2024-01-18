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