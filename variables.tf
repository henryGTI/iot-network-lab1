variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "cctv_subnet_cidr" {
  description = "CIDR block for the CCTV subnet"
  type        = string
}

variable "temp_subnet_cidr" {
  description = "CIDR block for the TempSensor subnet"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}
