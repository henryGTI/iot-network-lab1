# 🌐 NAT Gateway 모듈 설명 (`modules/nat`)

이 모듈은 TempSensor용 프라이빗 서브넷에서 인터넷 아웃바운드 통신을 가능하게 하기 위해 NAT Gateway 및 전용 라우팅 테이블을 구성합니다.

## 📦 포함 리소스
- `aws_eip` (NAT Gateway용 탄력 IP)
- `aws_nat_gateway`
- `aws_route_table` (프라이빗 라우팅용)
- `aws_route_table_association`

## 🛠️ 입력 변수
- `vpc_id`: 대상 VPC ID
- `public_subnet_id`: NAT Gateway를 생성할 퍼블릭 서브넷 ID
- `private_subnet_id`: 프라이빗 서브넷 ID (TempSensor용) – 이 서브넷에 라우팅 테이블 연결

## 📤 출력 값
- NAT Gateway ID
- TempSensor 프라이빗 라우팅 테이블 ID

## 💡 유의사항
- NAT Gateway는 퍼블릭 서브넷 내에서만 생성 가능
- TempSensor는 퍼블릭 IP 없이도 아웃바운드 인터넷 통신이 가능해짐
- 인터넷 게이트웨이는 TempSensor Subnet에 직접 연결되지 않음
