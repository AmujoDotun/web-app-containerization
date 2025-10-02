output "vpc_cni_addon_id" {
  description = "ID of the VPC CNI add-on"
  value       = aws_eks_addon.vpc_cni.id
}

output "coredns_addon_id" {
  description = "ID of the CoreDNS add-on"
  value       = aws_eks_addon.coredns.id
}

output "kube_proxy_addon_id" {
  description = "ID of the kube-proxy add-on"
  value       = aws_eks_addon.kube_proxy.id
}

output "ebs_csi_driver_addon_id" {
  description = "ID of the EBS CSI Driver add-on"
  value       = aws_eks_addon.ebs_csi_driver.id
}

output "vpc_cni_role_arn" {
  description = "ARN of the IAM role for VPC CNI"
  value       = aws_iam_role.vpc_cni.arn
}

output "ebs_csi_driver_role_arn" {
  description = "ARN of the IAM role for EBS CSI Driver"
  value       = aws_iam_role.ebs_csi_driver.arn
}
