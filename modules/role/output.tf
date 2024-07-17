output "CLOUD_WATCH_EVENT_ROLE_ARN" {
  value = aws_iam_role.cloud_watch_event_role.arn
}
output "CLOUD_WATCH_EVENT_ROLE_NAME" {
  value = aws_iam_role.cloud_watch_event_role.name
}


output "CODEBUILD_ROLE_ARN" {
  value = aws_iam_role.codebuild_role.arn
}
output "CODEBUILD_ROLE_NAME" {
  value = aws_iam_role.codebuild_role.name
}


output "CODEBUILD_DEPLOY_ROLE_ARN" {
  value = aws_iam_role.codebuild_deploy_role.arn
}
output "CODEBUILD_DEPLOY_ROLE_NAME" {
  value = aws_iam_role.codebuild_deploy_role.name
}


output "CODEPIPELINE_ROLE_ARN" {
  value = aws_iam_role.codepipeline_role.arn
}
output "CODEPIPELINE_ROLE_NAME" {
  value = aws_iam_role.codepipeline_role.name
}