provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./vpc"
}

module "instances" {
  source          = "./instances"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  rds_subnets     = module.vpc.rds_subnets
}

module "alb" {
  source          = "./alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
}

module "rds" {
  source          = "./rds"
  vpc_id          = module.vpc.vpc_id
  rds_subnets     = module.vpc.rds_subnets
  db_subnet_group = module.vpc.db_subnet_group
}

