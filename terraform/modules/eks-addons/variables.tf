variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster's OIDC Issuer"
  type        = string
}

variable "vpc_cni_version" {
  description = "Version of the VPC CNI add-on"
  type        = string
  default     = null 
}

variable "coredns_version" {
  description = "Version of the CoreDNS add-on"
  type        = string
  default     = null 
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy add-on"
  type        = string
  default     = null 
}

variable "ebs_csi_driver_version" {
  description = "Version of the EBS CSI Driver add-on"
  type        = string
  default     = null 
}
