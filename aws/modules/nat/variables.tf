# modules/nat/variables.tf

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the subnet for NAT Gateway"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the subnet to associate with private route table"
  type        = string
}
