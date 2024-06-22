# provider.tf
provider "aws" {
  region = "eu-west-3"
}

provider "null" {
 
}

# variables.tf
variable "instance_type" {
  default = "t2.medium"
}

variable "cluster_size" {
  default = 3
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "SparkMongoDB"  
}

# spark_cluster.tf
resource "aws_instance" "spark_master" {
  count         = 1
  ami           = "ami-0fda19674ff597992"
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.spark_sg.id]

  tags = {
    Name = "Spark Master"
  }
}

resource "null_resource" "provision_spark_master" {
  depends_on = [aws_instance.spark_master]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip",
      "pip3 install ansible"
    ]

    connection {
      type        = "ssh"
      user        = "admin01"
      private_key = file("/home/admin01/Projet01/SparkMongoDB.pem")
      host        = aws_instance.spark_master[0].public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.spark_master[0].public_ip},' -u admin01 --private-key /home/admin01/Projet01/SparkMongoDB.pem install_spark.yml"
  }
}

resource "aws_instance" "spark_workers" {
  count         = var.cluster_size - 1
  ami           = "ami-0fda19674ff597992"
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.spark_sg.id]

  tags = {
    Name = "Spark Worker ${count.index + 1}"
  }
}

resource "null_resource" "provision_spark_workers" {
  count = var.cluster_size - 1
  depends_on = [aws_instance.spark_workers]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip",
      "pip3 install ansible"
    ]

    connection {
      type        = "ssh"
      user        = "admin01"
      private_key = file("/home/admin01/Projet01/SparkMongoDB.pem")
      host        = aws_instance.spark_workers[count.index].public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.spark_workers[count.index].public_ip},' -u admin01 --private-key /home/admin01/Projet01/SparkMongoDB.pem install_spark.yml"
  }
}

# network.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
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
