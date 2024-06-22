# provider.tf
provider "aws" {
  region = "us-west-3"
}

# variables.tf
variable "instance_type" {
  default = "t2.medium"
}

variable "cluster_size" {
  default = 3
}

# spark_cluster.tf
resource "aws_instance" "spark_master" {
  count         = 1
  ami           = "ami-0abcdef1234567890"
  instance_type = var.instance_type
  key_name      = "my-key"

  tags = {
    Name = "Spark Master"
  }
}

resource "aws_instance" "spark_workers" {
  count         = var.cluster_size - 1
  ami           = "ami-0abcdef1234567890"
  instance_type = var.instance_type
  key_name      = "my-key"

  tags = {
    Name = "Spark Worker ${count.index + 1}"
  }
}

# network.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "spark_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
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
resource "aws_network_interface_sg_attachment" "spark_master_sg" {
  security_group_id    = aws_security_group.spark_sg.id
  network_interface_id = aws_instance.spark_master.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "spark_worker_sg" {
  count                = var.cluster_size - 1
  security_group_id    = aws_security_group.spark_sg.id
  network_interface_id = aws_instance.spark_workers[count.index].primary_network_interface_id
}
