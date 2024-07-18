locals {
  RESOURCE_PREFIX = "${lower(var.ENV)}"
  REPOSITORY_NAME ="${var.REPOSITORY_NAME}"
  CODE_PIPELINE_NAME = "${local.RESOURCE_PREFIX}-pipeline"
  CODEBUILD_VALIDATE_NAME = "${local.RESOURCE_PREFIX}-TerraformValidate"
  CODEBUILD_DEPLOY_NAME = "${local.RESOURCE_PREFIX}-TerraformDeploy"
}

module "role" {
  source = "./modules/role"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}


module "policies" {
  source = "./modules/policy"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  AWS_REGION = var.REGION
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  REPOSITORY_NAME = local.REPOSITORY_NAME
  CODE_PIPELINE_NAME = local.CODE_PIPELINE_NAME
  CODEBUILD_VALIDATE_NAME = local.CODEBUILD_VALIDATE_NAME
  CODEBUILD_DEPLOY_NAME = local.CODEBUILD_DEPLOY_NAME
  
  CLOUD_WATCH_EVENT_ROLE_NAME = module.role.CLOUD_WATCH_EVENT_ROLE_NAME
  CODEBUILD_ROLE_NAME = module.role.CODEBUILD_ROLE_NAME
  CODEBUILD_DEPLOY_ROLE_NAME = module.role.CODEBUILD_DEPLOY_ROLE_NAME
  CODEPIPELINE_ROLE_NAME = module.role.CODEPIPELINE_ROLE_NAME
  CODEBUILD_VALIDATE_ARN = module.codebuild.CODEBUILD_VALIDATE_ARN
}


# bucket for pipeline
module "s3" {
  source = "./modules/s3"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}


module "codebuild" {
  source = "./modules/code-build"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  COMMON_TAGS = local.common_tags
  AWS_REGION = var.REGION
  REPOSITORY_NAME = local.REPOSITORY_NAME
  CODEBUILD_NAME = local.CODEBUILD_VALIDATE_NAME
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  TF_ACTION = "plan"
  
  CODEBUILD_ROLE_ARN = module.role.CODEBUILD_ROLE_ARN
}


module "codebuild_deploy" {
  source = "./modules/code-build"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  COMMON_TAGS = local.common_tags
  AWS_REGION = var.REGION
  REPOSITORY_NAME = local.REPOSITORY_NAME
  CODEBUILD_NAME = local.CODEBUILD_DEPLOY_NAME
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  TF_ACTION = "apply -auto-approve"
  
  CODEBUILD_ROLE_ARN = module.role.CODEBUILD_DEPLOY_ROLE_ARN
}


module "codepipeline" {
  source = "./modules/code-pipeline"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  COMMON_TAGS = local.common_tags
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  
  CODEPIPELINE_ROLE_ARN = module.role.CODEPIPELINE_ROLE_ARN
  CODEPIPELINE_BUCKET = module.s3.CODEPIPELINE_BUCKET
  REPOSITORY_NAME = local.REPOSITORY_NAME
  CODEBUILD_VALIDATE_NAME = local.CODEBUILD_VALIDATE_NAME
  CODEBUILD_DEPLOY_NAME = local.CODEBUILD_DEPLOY_NAME

  depends_on = [
    module.codebuild,
    module.codebuild_deploy,
    module.s3
  ]
}


module "cloudwatch_event" {
  source = "./modules/cloudwatch-event"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  AWS_REGION = var.REGION
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  CLOUD_WATCH_EVENT_ROLE_ARN = module.role.CLOUD_WATCH_EVENT_ROLE_ARN
  REPOSITORY_NAME = local.REPOSITORY_NAME
  CODE_PIPELINE_NAME = local.CODE_PIPELINE_NAME

  depends_on = [
    module.role
  ]
}