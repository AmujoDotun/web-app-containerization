module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  availability_zones = var.availability_zones
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source                  = "./modules/eks"
  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_cluster_version     = var.eks_cluster_version
  instance_type           = var.instance_type
  desired_node_count      = var.desired_node_count
  min_node_count          = var.min_node_count
  max_node_count          = var.max_node_count
}