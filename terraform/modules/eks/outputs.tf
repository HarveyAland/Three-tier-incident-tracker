output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks_node_group_name" {
  value = aws_eks_node_group.default.node_group_name
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_nodes.id
}