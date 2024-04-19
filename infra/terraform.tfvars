project_name    = "eks_api_python"
region          = "us-east-2"
accountID       = "332241128212"

ecr_repository  = "app-repository"
tag_mutability  = "MUTABLE"
bucket_pipeline = "python-api-build-artifacts"
compute_type    = "BUILD_GENERAL1_SMALL"
image_cb        = "aws/codebuild/standard:5.0"
type_cb         = "LINUX_CONTAINER"
tag_cb             = "latest"


type_resource_cb = "GITHUB"
location_url     = "https://github.com/iriscafe/devops-test"
path_buildspec   = "./infra/modules/codepipeline/spec/buildspec.yaml"