output "spark_master_public_ip" {
  value = aws_instance.spark_master[0].public_ip
}

output "spark_workers_public_ip" {
  value = [for i in aws_instance.spark_workers : i.public_ip]
}
