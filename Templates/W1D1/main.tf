# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "dci-tera-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "ExampleBucket"
    Environment = "Production"
  }
}

# Output the bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
