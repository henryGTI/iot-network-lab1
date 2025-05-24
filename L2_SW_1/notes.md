# L2_SW_1 - 엣지 스위치 (CCTV & NVR 연결)

## 📌 장비 개요
- 역할: VLAN 10 (CCTV & NVR) 장비 연결 담당
- 스위치 유형: L2 엣지 스위치
- 관리 인터페이스: VLAN10 (SVI) - [REDACTED_IP]

## 🌐 VLAN 구성
| VLAN ID | 용도        | SVI IP          |
|---------|-------------|-----------------|
| 10      | CCTV & NVR  | [REDACTED_IP]   |
| 20      | 제어장비용  | [REDACTED_IP]   |

## 📥 포트 맵
| 인터페이스 범위          | VLAN | 설명              |
|--------------------------|------|-------------------|
| Gi0/1 ~ Gi0/3            | 10   | CCTV & NVR 연결   |
| Gi1/1 ~ Gi1/3            | 20   | 제어 장비 연결    |
| Gi0/0                    | 10   | VLAN10 Uplink     |
| Gi1/0                    | 20   | VLAN20 Uplink     |

## 🛡️ 보안 정책
- 적용 ACL: `Spoofing_DDOS`
  - RFC 1918 / loopback / multicast / APIPA 차단
- SSH 접속 제어: `deny_ssh` ACL로 VTY 접근 제한
- LLDP: 비활성화됨
- SNMP:
  - SNMPv2 커뮤니티: `[REDACTED_COMMUNITY]`
  - SNMPv3 사용자: `[REDACTED_USER]`
  - 허용 IP: `[REDACTED_IP]`

## 🧭 기본 라우트
- 기본 경로1: `[REDACTED_IP]`
- 백업 경로2: `[REDACTED_IP]` (AD 10)

## ⚙️ 기타 설정
- 콘솔 로그인 타임아웃: 120초
- VTY 로그인 타임아웃: 120초
- MOTD 배너 설정됨
- syslog 서버: `[REDACTED_IP]` 로 로그 전송
