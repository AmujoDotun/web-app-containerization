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

module "eks_addons" {
  source = "./modules/eks-addons"

  cluster_name            = module.eks.cluster_name
  cluster_version         = module.eks.cluster_version
  oidc_provider_arn       = module.eks.oidc_provider_arn
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  depends_on = [module.eks]
}

module "aws_lb_controller" {
  source = "./modules/aws-lb-controller"

  cluster_name            = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn
  vpc_id                  = module.vpc.vpc_id
  aws_region              = var.aws_region

  depends_on = [module.eks, module.eks_addons]
}