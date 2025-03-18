# Define the variable with validation
variable "instance_count" {
  type        = number
  description = "The number of instances to create."

  validation {
    condition     = var.instance_count > 0
    error_message = "Must be a positive integer."
  }
}

# Specify the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create EC2 instances based on the instance_count variable
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance-${count.index + 1}"
  }
}

# Output the instance IDs
output "instance_ids" {
  value = aws_instance.example[*].id
}
