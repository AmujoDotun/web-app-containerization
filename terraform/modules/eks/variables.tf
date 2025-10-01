variable "project_name" {
  description = "The name of the project for tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS worker nodes."
  type        = list(string)
}

variable "eks_cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the EKS worker nodes."
  type        = string
}

variable "desired_node_count" {
  description = "The desired number of worker nodes."
  type        = number
}

variable "min_node_count" {
  description = "The minimum number of worker nodes."
  type        = number
}

variable "max_node_count" {
  description = "The maximum number of worker nodes."
  type        = number
}