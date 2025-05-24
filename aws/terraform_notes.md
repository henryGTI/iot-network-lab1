# 📘 Terraform 구성 설명 (`main.tf` 기준)

이 문서는 `main.tf` 파일에 정의된 AWS 리소스 구성을 설명합니다.  
IoT 네트워크(예: CCTV, 온도센서 등)를 AWS 인프라로 구현한 구조입니다.

---

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
