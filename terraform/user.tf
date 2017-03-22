provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "deployuser" {
  name = "deployuser"
  path = "/"
}

resource "aws_iam_access_key" "deployuser" {
  user = "${aws_iam_user.deployuser.name}"
}

resource "aws_iam_user_policy" "deployuser_policy" {
  name = "s3"
  user = "${aws_iam_user.deployuser.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
