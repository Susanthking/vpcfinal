resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/example-key.pem"
  file_permission = "0400"
}
resource "aws_instance" "public" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = element(var.public_subnets, count.index)
  key_name      = aws_key_pair.example.key_name

  tags = {
    Name = "PublicInstance-${count.index}"
  }
}

resource "aws_instance" "private" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnets, count.index)
  key_name      = aws_key_pair.example.key_name

  tags = {
    Name = "PrivateInstance-${count.index}"
  }
}

provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key.filename}"
  }

variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "rds_subnets" {
  type = list(string)
}

