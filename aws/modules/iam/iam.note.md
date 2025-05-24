# 🔐 IAM 모듈 설명 (`modules/iam`)

이 모듈은 EC2 인스턴스에서 CloudWatch Logs에 접근할 수 있도록 필요한 IAM 리소스를 정의합니다.

## 📦 포함 리소스
- `aws_iam_role` (ec2_cloudwatch_role)
- `aws_iam_role_policy_attachment` (CloudWatchAgentServerPolicy)
- `aws_iam_instance_profile`

## 🛠️ IAM 역할 정책
- EC2 인스턴스가 `cloudwatch:PutLogEvents`, `logs:CreateLogGroup` 등의 작업을 수행 가능하도록 AWS 관리형 정책 `CloudWatchAgentServerPolicy`를 연결

## 🧾 출력 값
- `ec2_profile_name`: EC2 인스턴스에 연결될 IAM Instance Profile 이름 (EC2 모듈에서 사용됨)

## 💡 유의사항
- CloudWatch Agent가 설치된 EC2 인스턴스에서는 로그 스트리밍이 자동 수행됨
- EC2 모듈에서 이 프로파일을 필수로 연결해야 CloudWatch 로그 접근 가능
