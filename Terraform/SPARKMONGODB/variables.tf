variable "region" {
  description = "The AWS region to deploy to"
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "Name of the EMR cluster"
  default     = "SparkCluster01"
}

variable "release_label" {
  description = "EMR release label"
  default     = "emr-7.1.0"
}

variable "applications" {
  description = "Applications to install on EMR cluster"
  type        = list(string)
  default     = ["Hadoop", "Hive", "JupyterEnterpriseGateway", "Livy", "Spark"]
}

variable "service_role" {
  description = "IAM service role for EMR"
  default     = "arn:aws:iam::031131961798:role/service-role/AmazonEMR-ServiceRole-20240505T140225"
}

variable "log_uri" {
  description = "S3 bucket for EMR logs"
  default     = "s3://s3-spark-mongodb"
}

variable "instance_profile" {
  description = "IAM instance profile for EC2 instances"
  default     = "arn:aws:iam::031131961798:instance-profile/EmrEc2S3Full"
}

variable "subnet_id" {
  description = "Subnet ID for the EMR cluster"
  default     = "subnet-00508a1e4ac0faf28"
}

variable "master_security_group" {
  description = "Security group for master instances"
  default     = "sg-01ceb80944ffa01d6"
}

variable "slave_security_group" {
  description = "Security group for slave instances"
  default     = "sg-0852ccf141b26f385"
}

variable "key_name" {
  description = "Key name for SSH access"
  default     = "SSH_Mongodb"
}

variable "mongodb_ami" {
  description = "AMI for MongoDB instance"
  default     = "ami-087da76081e7685da"
}

variable "mongodb_instance_type" {
  description = "Instance type for MongoDB"
  default     = "t2.micro"
}

variable "pem_path" {
  description = "Path to the PEM file for SSH access"
  default     = "admin01@devops03:~/Projet01/SparkMongoDB.pem"
}
variable "ssh_user" {
  description = "SSH username for the instances"
  default     = "root"
}
