resource "aws_emr_cluster" "Spark_Cluster" {
  name          = var.cluster_name
  release_label = var.release_label
  applications  = var.applications
  service_role  = var.service_role
  log_uri       = var.log_uri

  ec2_attributes {
    instance_profile                  = var.instance_profile
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group = var.master_security_group
    emr_managed_slave_security_group  = var.slave_security_group
    key_name                          = var.key_name
  }

  master_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
    name           = "Primaire"
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 2
    name           = "Unité principale et unité de tâches"
  }

  configurations_json = jsonencode([
    {
      Classification = "spark-defaults",
      Properties = {
        "spark.jars.packages" = "org.mongodb.spark:mongo-spark-connector_2.12:3.0.1",
        "spark.mongodb.input.uri" = "mongodb://[admin01]:[1234]@[mongodb]:27017/[database01]",
        "spark.mongodb.output.uri" = "mongodb://[admin01]:[1234]@[mongodb]:27017/[database01]"
      }
    }
  ])

  scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"
  auto_termination_policy {
    idle_timeout = 3600
  }
}

resource "aws_instance" "mongodb" {
  ami           = var.mongodb_ami
  instance_type = var.mongodb_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.master_security_group, var.slave_security_group]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y mongodb
              sudo systemctl start mongodb
              sudo systemctl enable mongodb
              EOF

  tags = {
    Name = "MongoDB Server"
  }
}
