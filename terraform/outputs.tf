output "vpc_id" {
  value = module.vpc.vpc_id
}

#utput "public_subnets" {
  #value = module.vpc.public_subnets
#}

#output "private_subnets" {
  #value = module.vpc.private_subnets
#}

output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_node_group_name" {
  value = module.eks.eks_node_group_name
}

output "ecr_frontend_repo_url" {
  description = "URL of the ECR repository for the frontend"
  value       = module.ecr.frontend_repo_url
}

output "ecr_backend_repo_url" {
  description = "URL of the ECR repository for the backend"
  value       = module.ecr.backend_repo_url
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}