resource "aws_instance" "cctv" {
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t2.micro"
  subnet_id                   = var.cctv_subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile
  tags = {
    Name = "cctv-instance"
  }
}

resource "aws_instance" "temp" {
  ami                  = "ami-0c9c942bd7bf113a2"
  instance_type        = "t2.micro"
  subnet_id            = var.temp_subnet_id
  iam_instance_profile = var.iam_instance_profile
  tags = {
    Name = "tempsensor-instance"
  }
}

output "cctv_public_ip" {
  value = aws_instance.cctv.public_ip
}

output "temp_private_ip" {
  value = aws_instance.temp.private_ip
}
