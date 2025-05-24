# IoT Network Lab 1

EVE-NG 기반의 IoT 네트워크 실습 구성을 저장하는 저장소입니다.

## 구성 장비

- L2_SW_1: CCTV 및 TempSensor가 연결된 엣지 스위치
- Firewall: VLAN 보안 분리
- L2_SW_2 / L3_SW: 코어/백본 스위치
- Endpoints: CCTV와 TempSensor

## 토폴로지

![topology](topology.png)


# 📦 클라우드 구현 (AWS 기반 IoT 네트워크)

이 프로젝트는 Terraform을 활용해 IoT 장비(CCTV, TempSensor)를 위한 AWS 인프라를 코드로 구현합니다.

---

## 📁 주요 구성 파일 및 디렉토리

| 경로 | 설명 |
|------|------|
| `aws/main.tf` | 모듈 호출 중심 루트 파일 |
| `aws/variables.tf` | 변수 선언 파일 |
| `aws/terraform.tfvars` | 입력값 정의 파일 |
| `aws/modules/` | 기능별 리소스 모듈 구성 (vpc, ec2, iam, nat) |
| `aws/topology.png` | 전체 네트워크 구조도 |
| `aws/terraform_notes.md` | 전체 인프라 구성 설명 및 변경이력 문서 |

---

## 🧱 모듈별 구성 요약

- **VPC 모듈**: 10.0.0.0/16 네트워크 생성, CCTV/TempSensor 서브넷 분리
- **EC2 모듈**: CCTV(퍼블릭), TempSensor(프라이빗) 인스턴스 생성
- **IAM 모듈**: CloudWatch 로그 수집을 위한 역할과 인스턴스 프로파일 생성
- **NAT 모듈**: TempSensor 프라이빗 서브넷용 NAT Gateway 및 라우팅 테이블 구성

---

## 🌐 네트워크 구성 요약

| 구성요소 | 설명 |
|----------|------|
| **CCTV** | 퍼블릭 Subnet, RTSP 허용 (TCP 554) |
| **TempSensor** | 프라이빗 Subnet, MQTT 허용 (TCP 1883) - 내부 접근만 |
| **인터넷 연결** | IGW는 CCTV용, NAT Gateway는 TempSensor용 아웃바운드용 |

---

## 🚀 배포 방법

```bash
terraform init
terraform plan
terraform apply
```

✅ AWS 리전을 `terraform.tfvars`에서 설정 가능 (`ap-northeast-2` 등)

---

## 📌 기타 참고

- EC2 AMI ID는 `terraform.tfvars` 또는 모듈 내부에서 정의 필요
- `CloudWatch Agent`는 인스턴스에 설치되어야 로그 수집 가능
- 모든 코드는 모듈 단위로 재사용 가능하도록 작성됨

