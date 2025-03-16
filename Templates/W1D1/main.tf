# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "dci-tera-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "ExampleBucket"
    Environment = "Production"
  }
}

# Create an IAM user
resource "aws_iam_user" "example_user" {
  name = "example_user"
}

# Create an IAM role
resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.example_user.arn
        }
      }
    ]
  })
}

# Attach a policy to the IAM role to allow S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Policy to allow access to the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.example_bucket.arn,
          "${aws_s3_bucket.example_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Output the bucket name, user ARN, and role ARN
output "s3_bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}

output "iam_user_arn" {
  value = aws_iam_user.example_user.arn
}

output "iam_role_arn" {
  value = aws_iam_role.example_role.arn
}
