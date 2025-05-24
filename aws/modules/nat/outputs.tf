# modules/nat/outputs.tf

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "private_route_table_id" {
  description = "ID of the route table associated with private subnet"
  value       = aws_route_table.temp_rt.id
}
