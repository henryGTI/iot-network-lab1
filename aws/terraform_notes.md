# 📘 Terraform 구성 설명 (`main.tf` 기준)

이 문서는 `main.tf` 및 모듈 구조를 기반으로 AWS 리소스 구성을 설명합니다.  
IoT 네트워크(예: CCTV, 온도센서 등)를 AWS 인프라로 구현한 구조입니다.

---

## 📐 아키텍처 구성 개요

| 항목                   | 설명                                                           |
|------------------------|----------------------------------------------------------------|
| **VPC**                | 10.0.0.0/16                                                    |
| **Subnet - CCTV**      | 10.0.10.0/24 (인터넷 접근 가능, VLAN 10 대응)                 |
| **Subnet - TempSensor**| 10.0.20.0/24 (인터넷 차단, VLAN 20 대응)                      |
| **Internet Gateway**   | CCTV 전용                                                     |
| **Route Table**        | CCTV 전용 라우팅 설정                                         |
| **Security Group - CCTV**| RTSP (TCP 554) 허용                                          |
| **Security Group - TempSensor** | MQTT (TCP 1883) 허용, CCTV Subnet에서만 허용       |

---

## 🏗️ VPC 구성

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

---

## 🧱 모듈 구조 개요

Terraform 구성을 `modules/` 디렉토리 하위에 기능별로 분리하여 재사용성과 유지보수를 높였습니다.

### 📁 디렉토리 구조
```
iot-network-lab1/
└── aws/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    ├── README.md
    ├── terraform_notes.md
    ├── topology.png
    └── modules/
        ├── vpc/
        │   └── main.tf
        ├── ec2/
        │   └── main.tf
        └── iam/
            └── main.tf
```

### 📦 모듈별 역할

| 모듈        | 역할 설명                                       |
|-------------|--------------------------------------------------|
| `vpc`       | VPC, CCTV/TempSensor Subnet 생성 및 출력        |
| `ec2`       | CCTV 및 TempSensor EC2 인스턴스 생성            |
| `iam`       | EC2에서 CloudWatch 로그를 전송할 수 있는 IAM 구성 |

루트 `main.tf`에서는 각 모듈을 호출하고, 출력값은 `outputs.tf`에 정리합니다.  
변수는 `variables.tf`에서 선언하고, 값은 `terraform.tfvars`로 분리합니다.

---

## 📌 변경사항 정리 (Change Log)

| 날짜       | 변경 내용                                                         |
|------------|------------------------------------------------------------------|
| 2025-05-24 | 프로젝트 초기 구성 완료: VPC, Subnet, SG 정의                    |
| 2025-05-24 | CCTV / TempSensor 서브넷 분리 구성 (VLAN 10 / 20 대응)          |
| 2025-05-24 | 모듈화 적용: vpc, ec2, iam 디렉토리 구조 반영                    |
| 2025-05-24 | 루트 디렉토리 변수 파일 `variables.tf`, 출력파일 `outputs.tf` 추가 |
| 2025-05-24 | `terraform.tfvars` 값 파일 생성 및 커밋                          |
| 2025-05-24 | 디렉토리 구조 통일 및 `README.md`, `topology.png` 반영           |
