terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "dci-teacher-aws"

    workspaces {
      name = "Terraform"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_instance" "my_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name        = "MyEC2Instance"
    Environment = var.environment
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}

output "instance_id" {
  description = "Id of my instance"
  value = aws_instance.my_instance.id
}

output "instance_ip" {
  description = "Public Ip of main server instance"
  value = aws_instance.my_instance.public_ip
}
