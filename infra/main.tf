module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "eks" {

  depends_on = [
    module.vpc
  ]

  source          = "./modules/eks"
  project_name    = var.project_name

  network = {
    vpc_id  = module.vpc.vpc_id
    subnets = [module.vpc.subnet_public_one_id, module.vpc.subnet_public_two_id, module.vpc.subnet_private_one_id, module.vpc.subnet_private_two_id]
  }
}

module "codepipeline"{

  depends_on = [
    module.eks
  ]

  source       = "./modules/codepipeline"
  project_name = var.project_name
}