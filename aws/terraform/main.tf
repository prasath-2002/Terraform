provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source       = "../modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  azs          = var.azs
}

module "alb" {
  source     = "../modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}

module "ec2" {
  source           = "../modules/ec2"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.subnet_ids
  target_group_arn = module.alb.target_group_arn
  alb_sg_id        = module.alb.alb_sg_id
}

module "rds" {
  source     = "../modules/rds"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}

module "s3" {
  source      = "../modules/s3"
  bucket_name = var.bucket_name
}