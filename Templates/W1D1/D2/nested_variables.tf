# Define a nested list for subnets
variable "subnets" {
  type = list(list(string))
  default = [
    ["subnet-1a", "subnet-1b"],
    ["subnet-2a", "subnet-2b"]
  ]
}

# Define a nested map for instance configurations
variable "instance_types" {
  type = map(object({
    instance_type = string
    count         = number
  }))
  default = {
    "web" = {
      instance_type = "t2.micro"
      count         = 2
    }
    "db" = {
      instance_type = "t2.medium"
      count         = 1
    }
  }
}

# Create subnets using the nested list
resource "aws_subnet" "example" {
  count = length(var.subnets) * length(var.subnets[0]) # Total number of subnets

  vpc_id     = aws_vpc.example.id
  cidr_block = cidrsubnet(aws_vpc.example.cidr_block, 8, count.index)
  }
}

# Create EC2 instances using the nested map
resource "aws_instance" "example" {
  for_each = var.instance_types

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value.instance_type

  count = each.value.count

  subnet_id = aws_subnet.example[count.index % length(aws_subnet.example)].id

  tags = {
    Name = "${each.key}-instance-${count.index + 1}"
  }
}

# Output the subnet IDs
output "subnet_ids" {
  value = aws_subnet.example[*].id
}

# Output the instance IDs
output "instance_ids" {
  value = flatten([
    for instance in aws_instance.example : instance[*].id
  ])
}
