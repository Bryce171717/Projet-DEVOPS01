output "cluster_id" {
  value = aws_emr_cluster.Spark_Cluster.id
}

output "master_public_dns" {
  value = aws_emr_cluster.Spark_Cluster.master_public_dns
}

output "mongodb_instance_status" {
  value = aws_instance.mongodb.instance_state
}

output "mongodb_public_dns" {
  value = aws_instance.mongodb.public_dns
}

output "mongodb_public_ip" {
  value = aws_instance.mongodb.public_ip
}
