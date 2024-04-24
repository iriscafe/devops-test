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

  source           = "./modules/codepipeline"
  project_name     = var.project_name
  region           = var.region
  accountID        = var.accountID

  ecr_repository   = var.ecr_repository
  tag_mutability   = var.tag_mutability
  bucket_pipeline  = var.bucket_pipeline
  compute_type     = var.compute_type
  image_cb         = var.image_cb
  type_cb          = var.type_cb
  tag_cb           = var.tag_cb

  type_resource_cb = var.type_resource_cb
  location_url     = var.location_url
  path_buildspec   = var.path_buildspec
}

# module "argocd"{
#   source       = "./modules/argocd"
#   project_name = var.project_name
# }