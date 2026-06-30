# VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  project = var.project
  environment = var.environment
  private_a_cidr = var.private_a_cidr
  private_b_cidr = var.private_b_cidr
  public_a_cidr = var.public_a_cidr
  public_b_cidr = var.public_b_cidr
}

# SG
module "sg" {
  source = "./modules/sg"

  environment = var.environment
  project = var.project
  vpc_id = module.vpc.vpc_id
}

# IAM
module "iam" {
  source = "./modules/iam"

  environment = var.environment
  project = var.project
}

# ALB
module "alb" {
  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id
  project = var.project
  environment = var.environment
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id = module.sg.alb_sg_id
}

# ECR
module "ecr" {
  source = "./modules/ecr"

  project = var.project
  environment = var.environment
}

# ECS
module "ecs" {
  source = "./modules/ecs"

  project     = var.project
  environment = var.environment
  aws_region  = var.region

  alb_dns_name = module.alb.alb_dns_name
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_tasks_sg_id     = module.sg.ecs_tasks_sg_id

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  frontend_image_url = module.ecr.repository_urls["frontend"]
  backend_image_url  = module.ecr.repository_urls["backend"]

  frontend_target_group_arn = module.alb.frontend_target_group_arn
  backend_target_group_arn  = module.alb.backend_target_group_arn
}

# Jenkins
module "jenkins" {
  source = "./modules/jenkins"

  vpc_id = module.vpc.vpc_id
  environment = var.environment
  project = var.project
  public_subnet_id = module.vpc.public_subnet_ids[0]
  my_ip = var.my_ip
}
