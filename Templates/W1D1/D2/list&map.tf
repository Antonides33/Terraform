# Define a list variable
variable "instance_names" {
  type    = list(string)
  default = ["web-1", "web-2", "web-3"]
}

# Define a map variable
variable "instance_config" {
  type = map(object({
    instance_type = string
    ami           = string
  }))
  default = {
    "web" = {
      instance_type = "t2.micro"
      ami           = "ami-0c55b159cbfafe1f0"
    }
    "db" = {
      instance_type = "t2.medium"
      ami           = "ami-0c55b159cbfafe1f0"
    }
  }
}

# Create EC2 instances using the list variable
resource "aws_instance" "web" {
  count         = length(var.instance_names) # Use the length of the list
  ami           = var.instance_config["web"].ami
  instance_type = var.instance_config["web"].instance_type

  tags = {
    Name = var.instance_names[count.index] # Use the list to name instances
  }
}

# Create EC2 instances using the map variable
resource "aws_instance" "db" {
  ami           = var.instance_config["db"].ami
  instance_type = var.instance_config["db"].instance_type

  tags = {
    Name = "db-instance"
  }
}

# Output the list of web instance IDs
output "web_instance_ids" {
  value = aws_instance.web[*].id
}

# Output the DB instance ID
output "db_instance_id" {
  value = aws_instance.db.id
}
