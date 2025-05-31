variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., production)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
}