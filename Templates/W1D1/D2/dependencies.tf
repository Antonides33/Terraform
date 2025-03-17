# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Resource 1: Create a VPC (implicit dependency source)
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Resource 2: Create a Subnet (implicit dependency on the VPC)
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id  # Implicit dependency: references aws_vpc.example
  cidr_block = "10.0.1.0/24"
}

# Resource 3: Create an IAM Role (no direct dependency on the VPC or Subnet)
resource "aws_iam_role" "example" {
  name = "example_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Resource 4: Create an EC2 Instance (explicit dependency on the IAM Role)
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # Explicit dependency: ensures the IAM Role is created before the EC2 instance
  depends_on = [aws_iam_role.example]
}

# Resource 5: Create a Security Group (implicit dependency on the VPC)
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id  # Implicit dependency: references aws_vpc.example

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
