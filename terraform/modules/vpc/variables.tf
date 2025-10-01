variable "project_name" {
  description = "The name of the project for tagging resources."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones to deploy into."
  type        = list(string)
}