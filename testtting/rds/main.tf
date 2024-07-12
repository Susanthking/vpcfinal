resource "aws_db_instance" "this" {
  identifier        = "my-rds-instance"
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  db_subnet_group_name = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot       = true
  db_name  = "mydb"
  username = "admin"
  password = "password"
  }
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "vpc_id" {}
variable "rds_subnets" {
  type = list(string)
}
variable "db_subnet_group" {}

