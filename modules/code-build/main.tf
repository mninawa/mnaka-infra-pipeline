resource "aws_codebuild_project" "codebuild_validate" {
  name = var.CODEBUILD_NAME
  service_role  = var.CODEBUILD_ROLE_ARN

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_VAR_ENV"
      value = "dev"
    }

    environment_variable {
      name  = "TF_ACTION"
      value = var.TF_ACTION
    }
  }

  source {
    type = "CODECOMMIT"
    location = "https://git-codecommit.${var.AWS_REGION}.amazonaws.com/v1/repos/${var.REPOSITORY_NAME}"
    buildspec = "buildspec.yml"
    git_clone_depth = 1
  }

  source_version = "refs/heads/master"

  tags = var.COMMON_TAGS
}