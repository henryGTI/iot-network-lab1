# 📘 Terraform 구성 설명 (`main.tf` 기준)

이 문서는 `main.tf` 파일에 정의된 AWS 리소스 구성을 설명합니다.  
IoT 네트워크(예: CCTV, 온도센서 등)를 AWS 인프라로 구현한 구조입니다.

---

## 📐 아키텍처 구성 개요

| 항목                     | 설명                                                                 |
|--------------------------|----------------------------------------------------------------------|
| **VPC**                  | `10.0.0.0/16`                                                        |
| **Subnet - CCTV**        | `10.0.10.0/24` (인터넷 접근 가능, VLAN 10 대응)                    |
| **Subnet - TempSensor**  | `10.0.20.0/24` (인터넷 차단, VLAN 20 대응)                         |
| **Internet Gateway**     | CCTV 전용                                                            |
| **Route Table**          | CCTV 전용 라우팅 설정                                               |
| **Security Group - CCTV**| RTSP (TCP 554) 허용                                                  |
| **Security Group - TempSensor** | MQTT (TCP 1883) 허용, CCTV Subnet에서만 허용             |


## 🏗️ VPC 구성

VPC는 AWS 내에서 가상 네트워크를 정의합니다. 주요 설정은 다음과 같습니다:

```hcl
resource "aws_vpc" "iot_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "iot-vpc"
  }
}
```

- 전체 VPC IP 대역은 10.0.0.0/16 (65536 IP)
- DNS 호스트명 활성화로 EC2에 도메인 할당 가능
- 태그 iot-vpc는 리소스 식별용

## 🌐 Subnet 구성

▶ CCTV 서브넷 (퍼블릭, VLAN 10 대응)
```hcl
resource "aws_subnet" "cctv_subnet" {
  vpc_id                  = aws_vpc.iot_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "cctv-subnet"
  }
}
```

- 퍼블릭 IP 자동 할당 (인터넷 접근 가능)
- RTSP 영상 송출용 CCTV 장비 대상

▶ TempSensor 서브넷 (프라이빗, VLAN 20 대응)
```hcl
resource "aws_subnet" "tempsensor_subnet" {
  vpc_id                  = aws_vpc.iot_vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "tempsensor-subnet"
  }
}
```

- 퍼블릭 IP 없음 → 외부 차단
- 내부 온도센서 통신 전용

## 🚪 Internet Gateway (IGW)
```hcl
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.iot_vpc.id
  tags = {
    Name = "iot-igw"
  }
}
```
- VPC에 인터넷 연결 허용
- TempSensor Subnet에는 연결하지 않음

## 🛣️ 라우팅 테이블 (CCTV용)
```hcl
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
```
- CCTV Subnet에만 인터넷 경로 부여
- TempSensor는 경로 없음 (프라이빗 유지)

## 🔐 Security Group 구성
▶ CCTV 보안 그룹
```hcl
resource "aws_security_group" "cctv_sg" {
  name        = "cctv-sg"
  description = "Allow RTSP"
  vpc_id      = aws_vpc.iot_vpc.id

  ingress {
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
```
- RTSP(554번 포트) 전 세계 허용

▶ TempSensor 보안 그룹
```hcl
resource "aws_security_group" "tempsensor_sg" {
  name        = "tempsensor-sg"
  description = "Allow MQTT"
  vpc_id      = aws_vpc.iot_vpc.id

  ingress {
    from_port   = 1883
    to_port     = 1883
    protocol    = "tcp"
    cidr_blocks = ["10.0.10.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

```
- MQTT(1883번 포트) 허용
- CCTV Subnet에서만 접근 가능

## ✅ 구성 요약표

| 리소스                | 역할                           | 외부 접근 여부 |
|-----------------------|--------------------------------|----------------|
| VPC (`10.0.0.0/16`)   | 전체 네트워크 범위             | ❌             |
| CCTV Subnet           | RTSP 트래픽 송출용, 퍼블릭     | ✅             |
| TempSensor Subnet     | MQTT 통신용, 프라이빗          | ❌             |
| IGW + Route Table     | CCTV 전용 인터넷 연결          | ✅             |
| Security Groups       | 포트 기반 제어                 | 제한적 허용    |
