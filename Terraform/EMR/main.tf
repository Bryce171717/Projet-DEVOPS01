# provider.tf
provider "aws" {
  region = "eu-west-3"
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
  ami           = "ami-0fda19674ff597992"
  instance_type = var.instance_type
  key_name      = "my-key"

  tags = {
    Name = "Spark Master"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip",
      "pip3 install ansible"
    ]

    connection {
      type        = "ssh"
      user        = "admin01"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.spark_master[0].public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.spark_master[0].public_ip},' -u admin01 --private-key ~/.ssh/id_rsa install_spark.yml"
  }
}

resource "aws_instance" "spark_workers" {
  count         = var.cluster_size - 1
  ami           = "ami-0fda19674ff597992"
  instance_type = var.instance_type
  key_name      = "my-key"

  tags = {
    Name = "Spark Worker ${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip",
      "pip3 install ansible"
    ]

    connection {
      type        = "ssh"
      user        = "admin01"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.spark_workers[count.index].public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.spark_workers[count.index].public_ip},' -u admin01 --private-key ~/.ssh/id_rsa install_spark.yml"
  }
}

# network.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc
