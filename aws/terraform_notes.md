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

## 🔄 이후 확장 사항

### ✅ EC2 인스턴스
- CCTV 및 TempSensor 용도로 각각 EC2 인스턴스 생성
- 퍼블릭/프라이빗 서브넷에 연결하여 동작 테스트

### ✅ NAT Gateway 구성
- TempSensor Subnet의 아웃바운드 인터넷 접속을 위해 NAT Gateway 및 프라이빗 라우팅 테이블 추가 예정

### ✅ CloudWatch 로그 통합
- EC2에 IAM Role 부여 → CloudWatch Agent 정책 포함
- 로그 그룹 생성 및 로그 수집 설정 추가 예정

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
| 2025-05-24 | EC2 인스턴스, NAT Gateway, CloudWatch 로그 통합 계획 추가         |
