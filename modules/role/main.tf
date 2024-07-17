resource "aws_iam_role" "cloud_watch_event_role" {
  name = "${var.RESOURCE_PREFIX}-cloudwatch-event-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}



resource "aws_iam_role" "codebuild_role" {
  name = "${var.RESOURCE_PREFIX}-codebuild-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}



resource "aws_iam_role" "codebuild_deploy_role" {
  name = "${var.RESOURCE_PREFIX}-codebuild-deploy-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}



resource "aws_iam_role" "codepipeline_role" {
  name = "${var.RESOURCE_PREFIX}-codepipeline-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}