output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster's API server."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "The CA certificate for the EKS cluster."
  value       = module.eks.cluster_ca_certificate
}

output "region" {
  description = "The AWS region."
  value       = var.aws_region
}