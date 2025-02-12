resource "aws_iam_policy" "iam_s3_policy" {
  name        = "policy-terraform-tfstate"
  description = "Policy to access s3 bucket"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::bucket-bia-terraform"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::bucket-bia-terraform/terraform.tfstate"
    }
  ]

}
EOT
}