variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # Free tier eligible
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
  default = "terracloudtest22"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}
