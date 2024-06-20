resource "aws_emr_cluster" "spark_cluster" {
  name          = "SparkCluster01"
  release_label = "emr-7.1.0"
  applications  = [
    {
      Name = "JupyterEnterpriseGateway"
    },
    {
      Name = "Hive"
    },
    {
      Name = "Hadoop"
    },
    {
      Name = "Livy"
    },
    {
      Name = "Spark"
    }
  ]
  log_uri       = var.emr_log_uri

  ec2_attributes {
    instance_profile           = var.emr_instance_profile
    subnet_id                  = var.subnet_id
    emr_managed_master_security_group = var.emr_security_group_master
    emr_managed_slave_security_group  = var.emr_security_group_slave
    key_name                   = var.emr_key_name
  }

  configurations = <<EOF
  [
    {
      "Classification": "spark-defaults",
      "Properties": {
        "spark.jars.packages": "org.mongodb.spark:mongo-spark-connector_2.12:3.0.1",
        "spark.mongodb.input.uri": "mongodb://${var.mongodb_username}:${var.mongodb_password}@mongodb:27017/database01",
        "spark.mongodb.output.uri": "mongodb://${var.mongodb_username}:${var.mongodb_password}@mongodb:27017/database01"
      }
    }
  ]
  EOF

  master_instance_group {
    instance_type = "m5.xlarge"
    instance_count = 1
    name = "Master"
    ebs_config {
      ebs_block_device {
        volume_type = "gp2"
        size        = 32
        volumes_per_instance = 2
      }
    }
  }

  core_instance_group {
    instance_type = "m5.xlarge"
    instance_count = 2
    name = "Core"
    ebs_config {
      ebs_block_device {
        volume_type = "gp2"
        size        = 32
        volumes_per_instance = 2
      }
    }
  }

  scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"
  service_role        = var.emr_service_role
}
