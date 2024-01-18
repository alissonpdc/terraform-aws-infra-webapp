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