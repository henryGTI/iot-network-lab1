# IoT Network Lab - AWS VPC Terraform Template

provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
}

# VPC 생성
resource "aws_vpc" "iot_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support  = true
  enable_dns_hostnames = true
  tags = {
    Name = "iot-vpc"
  }
}

# Subnet - CCTV (VLAN 10 대응)
resource "aws_subnet" "cctv_subnet" {
  vpc_id                  = aws_vpc.iot_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "cctv-subnet"
  }
}

# Subnet - TempSensor (VLAN 20 대응)
resource "aws_subnet" "tempsensor_subnet" {
  vpc_id                  = aws_vpc.iot_vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "tempsensor-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.iot_vpc.id
  tags = {
    Name = "iot-igw"
  }
}

# Route Table - CCTV용 (인터넷 접근 가능)
resource "aws_route_table" "cctv_rt" {
  vpc_id = aws_vpc.iot_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "cctv-rt"
  }
}

resource "aws_route_table_association" "cctv_rta" {
  subnet_id      = aws_subnet.cctv_subnet.id
  route_table_id = aws_route_table.cctv_rt.id
}

# 보안 그룹 - CCTV
resource "aws_security_group" "cctv_sg" {
  name        = "cctv-sg"
  description = "Allow RTSP"
  vpc_id      = aws_vpc.iot_vpc.id

  ingress {
    description = "Allow RTSP"
    from_port   = 554
    to_port     = 554
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 보안 그룹 - TempSensor
resource "aws_security_group" "tempsensor_sg" {
  name        = "tempsensor-sg"
  description = "Allow MQTT"
  vpc_id      = aws_vpc.iot_vpc.id

  ingress {
    description = "Allow MQTT"
    from_port   = 1883
    to_port     = 1883
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24"] # CCTV subnet에서만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
