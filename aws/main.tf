# root main.tf

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "./modules/vpc"
  project           = var.project
  vpc_cidr          = var.vpc_cidr
  cctv_subnet_cidr  = var.cctv_subnet_cidr
  temp_subnet_cidr  = var.temp_subnet_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source              = "./modules/ec2"
  cctv_subnet_id      = module.vpc.cctv_subnet_id
  temp_subnet_id      = module.vpc.temp_subnet_id
  iam_instance_profile = module.iam.ec2_profile_name
}

module "nat" {
  source            = "./modules/nat"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.cctv_subnet_id
  private_subnet_id = module.vpc.temp_subnet_id
}
