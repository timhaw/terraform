resource "aws_iam_instance_profile" "example" {
  name = "example"
  role = aws_iam_role.example.name
}