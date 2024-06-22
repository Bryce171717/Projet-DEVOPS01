provider "aws" {
  region = "eu-west-3"
}

resource "aws_emr_cluster" "spark_cluster" {
  name          = "SparkCluster"
  release_label = "emr-7.1.0"
  applications  = ["Hadoop", "Hive", "JupyterEnterpriseGateway", "Livy", "Spark"]
  service_role  = "arn:aws:iam::031131961798:role/service-role/AmazonEMR-ServiceRole-20240505T140225"
  log_uri       = "s3://aws-logs-031131961798-eu-west-3/elasticmapreduce"
  tags = {
    "for-use-with-amazon-emr-managed-policies" = "true"
  }

  ec2_attributes {
    instance_profile          = "EmrEc2S3Full"
    emr_managed_master_security_group = "sg-01ceb80944ffa01d6"
    emr_managed_slave_security_group  = "sg-0852ccf141b26f385"
    subnet_id                 = "subnet-00508a1e4ac0faf28"
    additional_master_security_groups = []
    additional_slave_security_groups  = []
  }

  instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
    instance_role  = "TASK"
    name           = "Tâche - 1"

    ebs_config {
      size                = 32
      type                = "gp2"
      volumes_per_instance = 2
    }
  }

  instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
    instance_role  = "MASTER"
    name           = "Primaire"

    ebs_config {
      size                = 32
      type                = "gp2"
      volumes_per_instance = 2
    }
  }

  instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
    instance_role  = "CORE"
    name           = "Unité principale"

    ebs_config {
      size                = 32
      type                = "gp2"
      volumes_per_instance = 2
    }
  }

  scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"

  bootstrap_action {
    name = "Install necessary libraries"
    path = "s3://s3-spark-mongodb/bootstrap.sh"
  }

  configurations = <<EOF
[
  {
    "Classification": "spark-defaults",
    "Properties": {
      "spark.mongodb.input.uri": "mongodb://<username>:<password>@<mongodb_server>:27017/<database>.<collection>?authSource=<authSource>",
      "spark.mongodb.output.uri": "mongodb://<username>:<password>@<mongodb_server>:27017/<database>.<collection>?authSource=<authSource>"
    }
  }
]
EOF

  dynamic "step" {
    for_each = var.steps
    content {
      action_on_failure = lookup(step.value, "action_on_failure", "TERMINATE_CLUSTER")
      hadoop_jar_step {
        jar         = lookup(step.value, "jar")
        args        = lookup(step.value, "args", [])
        main_class  = lookup(step.value, "main_class", null)
        properties  = lookup(step.value, "properties", {})
      }
      name = step.value.name
    }
  }
}

variable "steps" {
  description = "List of steps to run on the cluster"
  type        = list(map(string))
  default     = []
}
