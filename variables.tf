variable "aws_region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-3"
}

variable "mongodb_username" {
  description = "Nom d'utilisateur administrateur pour MongoDB"
  type        = string
  sensitive   = true
}

variable "mongodb_password" {
  description = "Mot de passe administrateur pour MongoDB"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "ID du sous-réseau où les instances seront déployées"
  type        = string
  default     = "subnet-00508a1e4ac0faf28"
}

variable "emr_log_uri" {
  description = "URI du bucket S3 pour les logs EMR"
  type        = string
  default     = "s3://aws-logs-031131961798-eu-west-3/elasticmapreduce"
}

variable "emr_instance_profile" {
  description = "Profil d'instance IAM pour les instances EMR"
  type        = string
  default     = "arn:aws:iam::031131961798:instance-profile/EmrEc2S3Full"
}

variable "emr_service_role" {
  description = "Rôle de service IAM pour EMR"
  type        = string
  default     = "arn:aws:iam::031131961798:role/service-role/AmazonEMR-ServiceRole-20240505T140225"
}

variable "emr_security_group_master" {
  description = "Groupe de sécurité pour le master EMR"
  type        = string
  default     = "sg-01ceb80944ffa01d6"
}

variable "emr_security_group_slave" {
  description = "Groupe de sécurité pour les slaves EMR"
  type        = string
  default     = "sg-0852ccf141b26f385"
}

variable "emr_key_name" {
  description = "Nom de la clé SSH pour accéder aux instances EMR"
  type        = string
  default     = "SSH_Mongodb"
}

variable "mongodb_ami" {
  description = "AMI pour l'instance MongoDB"
  type        = string
  default     = "ami-087da76081e7685da"  # AMI Debian
}

variable "mongodb_key_name" {
  description = "Nom de la clé SSH pour accéder à MongoDB"
  type        = string
  default     = "SSH_Mongodb"
}

variable "mongodb_security_group" {
  description = "Groupe de sécurité pour MongoDB"
  type        = string
}
