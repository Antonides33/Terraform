variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "my-project"
}

locals {
  bucket_prefix = "${var.environment}-${var.project_name}"
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "${local.bucket_prefix}-bucket"
  tags   = local.common_tags
}

output "bucket_name" {
  value = local.bucket_prefix
}
