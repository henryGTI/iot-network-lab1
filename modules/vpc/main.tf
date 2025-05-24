resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "cctv" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cctv_subnet_cidr
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "cctv-subnet"
  }
}

resource "aws_subnet" "temp" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.temp_subnet_cidr
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "temp-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "cctv_subnet_id" {
  value = aws_subnet.cctv.id
}

output "temp_subnet_id" {
  value = aws_subnet.temp.id
}
