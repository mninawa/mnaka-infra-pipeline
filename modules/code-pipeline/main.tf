resource "aws_codepipeline" "codepipeline" {
  name     = "${var.RESOURCE_PREFIX}-pipeline"
  role_arn = var.CODEPIPELINE_ROLE_ARN

  artifact_store {
    location = var.CODEPIPELINE_BUCKET
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      run_order        = 1
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      namespace = "SourceVariables"
      output_artifacts = ["CodeWorkspace"]

      configuration = {
        RepositoryName = "${var.REPOSITORY_NAME}"
        BranchName       = "master"
        PollForSourceChanges = "false"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Terraform-plan"

    action {
      name             = "Build"
      run_order        = 2
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      namespace = "BuildVariables"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.CODEBUILD_VALIDATE_NAME
      }
    }
  }

  stage {
    name = "Terraform-apply"

    action {
      name             = "Deploy"
      run_order        = 3
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      namespace = "DeployVariables"
      input_artifacts  = ["CodeWorkspace"]
      output_artifacts = ["DeployArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.CODEBUILD_DEPLOY_NAME
      }
    }
  }
}