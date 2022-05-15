variable "aws_region" {
  description = "Aws region"
  type        = string
  default     = "eu-south-1"
}

variable "namespace_name" {
  description = "K8s namespace"
  type        = string
  default     = "test-blog-2"
}

variable "vpc_name" {
  description = "VPN name"
  type        = string
  default     = "AZ-vpc"
}

variable "cluster_name" {
  description = "K8s cluster name"
  type        = string
  default     = "K8sDemo"
}

variable "cluster_version" {
  description = "Cluster version"
  type        = string
  default     = "1.21"
}

variable "mongodb_username" {
  description = "Mongodb username"
  type = string
  default = "mongodbuser"
}
####################



variable "worker_group_mongodb_instance_type" {
  description = "Worker group mongodb instance type"
  type        = string
  default     = "t3.small"
}

variable "worker_group_mongodb_desidered_size" {
  description = "Worker group mongodb desidered size"
  type        = number
  default     = 3
}

variable "worker_group_webapp_instance_type" {
  description = "Worker group webapp instance type"
  type        = string
  default     = "t3.small"
}

variable "worker_group_webapp_desidered_size" {
  description = "Worker group webapp desidered size"
  type        = number
  default     = 1
}
