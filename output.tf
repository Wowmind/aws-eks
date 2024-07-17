output "eks_cluster_endpoint" {
    value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
    value = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster-security_group_id" {
    value = aws_security_group.eks_cluster_sg.id
}