variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "example" {
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 10
  username             = "admin"
  password             = var.db_password # Sensitive value
}

output "db_password" {
  value     = aws_db_instance.example.password
  sensitive = true
}
