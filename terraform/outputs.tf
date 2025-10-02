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
  sensitive   = true
}

output "region" {
  description = "The AWS region."
  value       = var.aws_region
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster's OIDC Issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

output "alb_controller_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = module.aws_lb_controller.alb_controller_role_arn
}

output "alb_controller_service_account" {
  description = "Name of the Kubernetes service account for AWS Load Balancer Controller"
  value       = module.aws_lb_controller.alb_controller_service_account
}

output "eks_addons_status" {
  description = "Status of installed EKS add-ons"
  value = {
    vpc_cni        = module.eks_addons.vpc_cni_addon_id
    coredns        = module.eks_addons.coredns_addon_id
    kube_proxy     = module.eks_addons.kube_proxy_addon_id
    ebs_csi_driver = module.eks_addons.ebs_csi_driver_addon_id
  }
}

output "kubectl_config_command" {
  description = "Command to update kubeconfig for kubectl access"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}