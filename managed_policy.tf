resource "aws_iam_policy" "example" {
    name        = "example"
    description = "A test policy"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:Describe*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "example" {
    role       = "${aws_iam_role.example.name}"
    policy_arn = "${aws_iam_policy.example.arn}"
}
