resource "aws_instance" "example" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.example.name
  subnet_id = aws_subnet.main-public-1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = var.SSH_KEY_PAIR
  associate_public_ip_address = true
}

