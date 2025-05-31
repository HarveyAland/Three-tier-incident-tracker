terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
  azs                  = ["eu-west-2a", "eu-west-2b"]
  name_prefix          = "prod"
  environment          = "production"
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = "eks-cluster-prod"
  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  environment         = "production"
  name_prefix         = "prod"
}

module "ecr" {
  source      = "./modules/ecr"
  name_prefix = "major-incident"
  tags = {
    Environment = "production"
    Project     = "ecommerce-app"
  }
}

module "rds" {
  source             = "./modules/rds"
  name_prefix        = "major-incident"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  eks_node_sg_id = module.eks.eks_node_sg_id

  db_name     = "major-incident"
  db_user     = "postgresadmin"
  db_password = "Password123" # Would be secure in real use
}