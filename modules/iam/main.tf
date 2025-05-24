resource "aws_iam_role" "ec2_role" {
  name = "ec2-cloudwatch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cw_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

output "ec2_profile_name" {
  value = aws_iam_instance_profile.profile.name
}
