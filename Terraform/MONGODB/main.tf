# provider.tf
provider "aws" {
  region = "us-west-2"
}

# variables.tf
variable "instance_type" {
  default = "t2.medium"
}

# mongodb.tf
resource "aws_instance" "mongodb" {
  count         = 1
  ami           = "ami-0fda19674ff597992"
  instance_type = var.instance_type
  key_name      = "my-key"

  tags = {
    Name = "MongoDB"
  }
}

# network.tf (reuse from Spark)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "mongodb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
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

# attach the security group to instances
resource "aws_network_interface_sg_attachment" "mongodb_sg" {
  security_group_id    = aws_security_group.mongodb_sg.id
  network_interface_id = aws_instance.mongodb.primary_network_interface_id
}
