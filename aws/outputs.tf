output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.iot_vpc.id
}

output "cctv_subnet_id" {
  description = "ID of the CCTV subnet"
  value       = aws_subnet.cctv_subnet.id
}

output "tempsensor_subnet_id" {
  description = "ID of the TempSensor subnet"
  value       = aws_subnet.tempsensor_subnet.id
}
