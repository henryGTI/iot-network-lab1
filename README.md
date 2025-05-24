# IoT Network Lab 1

EVE-NG 기반의 IoT 네트워크 실습 구성을 저장하는 저장소입니다.

## 구성 장비

- L2_SW_1: CCTV 및 TempSensor가 연결된 엣지 스위치
- Firewall: VLAN 보안 분리
- L2_SW_2 / L3_SW: 코어/백본 스위치
- Endpoints: CCTV와 TempSensor

## 토폴로지

![topology](topology.png)


## 📦 클라우드 구현 (AWS)

- `aws/main.tf`: IoT 네트워크를 위한 VPC 및 Subnet, SG 구성
- CCTV → 퍼블릭 Subnet (RTSP 허용)
- TempSensor → 프라이빗 Subnet (MQTT만 내부 접근 허용)
- Terraform으로 인프라 코드 기반 구성
