# 🏗️ VPC 모듈 설명 (`modules/vpc`)

이 모듈은 AWS에서 IoT 네트워크 인프라의 기본이 되는 VPC와 서브넷을 구성합니다.

## 📦 포함 리소스
- `aws_vpc` (iot-vpc)
- `aws_subnet` (cctv-subnet, tempsensor-subnet)
- `aws_internet_gateway`
- `aws_route_table` 및 `aws_route_table_association` (CCTV용)

## 🛠️ 입력 변수
- `project`: 리소스 식별용 prefix
- `vpc_cidr`: 전체 VPC CIDR 블록 (예: 10.0.0.0/16)
- `cctv_subnet_cidr`: 퍼블릭 CCTV 서브넷 CIDR (예: 10.0.10.0/24)
- `temp_subnet_cidr`: 프라이빗 TempSensor 서브넷 CIDR (예: 10.0.20.0/24)

## 📤 출력 값
- VPC ID
- CCTV Subnet ID
- TempSensor Subnet ID

## 💡 유의사항
- CCTV Subnet에는 IGW가 연결되어 인터넷 사용 가능
- TempSensor Subnet은 NAT Gateway를 통해서만 인터넷 접근 가능 (IGW 미연결)
