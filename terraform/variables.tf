variable "aws_region" {
  description = "The AWS region to deploy the infrastructure."
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
  default     = "scalable-web-service"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of availability zones to deploy into."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "eks_cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.30"
}

variable "instance_type" {
  description = "The EC2 instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_node_count" {
  description = "The desired number of worker nodes in the EKS cluster."
  type        = number
  default     = 2
}

variable "min_node_count" {
  description = "The minimum number of worker nodes."
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "The maximum number of worker nodes."
  type        = number
  default     = 4
}