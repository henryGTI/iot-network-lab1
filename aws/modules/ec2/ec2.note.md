# 📘 EC2 모듈 설명 (`modules/ec2`)

이 모듈은 CCTV 및 TempSensor 용도의 EC2 인스턴스를 생성합니다.

## 📦 포함 리소스
- aws_instance.cctv
- aws_instance.temp

## 🛠️ 입력 변수
- `cctv_subnet_id`: 퍼블릭 CCTV 인스턴스를 배치할 Subnet ID
- `temp_subnet_id`: 프라이빗 TempSensor 인스턴스를 배치할 Subnet ID
- `iam_instance_profile`: CloudWatch 로그 수집을 위한 IAM 인스턴스 프로파일 이름

## 💡 동작 설명
- CCTV 인스턴스는 퍼블릭 IP를 할당받으며, RTSP 서버 테스트에 사용됩니다.
- TempSensor 인스턴스는 NAT Gateway를 통해 인터넷 아웃바운드 접근만 허용됩니다.
- 두 인스턴스 모두 동일한 AMI와 인스턴스 타입(t2.micro)을 사용합니다.

## 🔐 권장 보안그룹
- CCTV: TCP 554 (RTSP)
- TempSensor: TCP 1883 (MQTT)
