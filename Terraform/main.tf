##########################################
# Terraform Configuration
##########################################
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "8byte-terraform-buck-devops"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }

}
##########################################
# Provider
##########################################
provider "aws" {
  region = var.aws_region
}

##########################################
# Locals
##########################################

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

##########################################
# VPC Module
##########################################
module "vpc" {
  source               = "./Module/VPC"
  vpc_name             = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  tags                 = local.common_tags
}

##########################################
# Security Group Module
##########################################
module "security_group" {
  source   = "./Module/SG"
  vpc_name = var.project_name
  vpc_id   = module.vpc.vpc_id
  tags     = local.common_tags

}
##########################################
# ALB Module
##########################################

module "alb" {
  source            = "./Module/ALB"
  vpc_name          = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
  tags              = local.common_tags
}
##########################################
# ECR Module
##########################################
module "ecr" {
  source          = "./Module/ECR"
  repository_name = "${var.project_name}-app"
  tags            = local.common_tags

}
##########################################
# ECS Module
##########################################

module "ecs" {
  source             = "./Module/ECS"
  vpc_name           = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.security_group.ecs_sg_id
  target_group_arn   = module.alb.target_group_arn
  repository_url     = module.ecr.repository_url
  aws_region         = var.aws_region
  tags               = local.common_tags
}
##########################################
# RDS Module
##########################################

module "rds" {
  source             = "./Module/RDS"
  vpc_name           = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_group.rds_sg_id
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  tags               = local.common_tags

}
#########################################
# CloudWatch Module
##########################################

module "cloudwatch" {
  source           = "./Module/Cloudwatch"
  vpc_name         = var.project_name
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  alb_arn_suffix   = module.alb.alb_arn_suffix
  rds_identifier   = module.rds.db_identifier

}