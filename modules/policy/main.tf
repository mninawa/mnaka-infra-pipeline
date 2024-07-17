resource "aws_iam_policy" "cwe_pipeline_execution_policy" {
  name = "${var.RESOURCE_PREFIX}-cwe-pipeline-execution-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codepipeline:StartPipelineExecution"
        ],
        Resource = [
          "arn:aws:codepipeline:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:${var.CODE_PIPELINE_NAME}"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "cwe_pipeline_execution_policy_attachment" {
  role       = "${var.CLOUD_WATCH_EVENT_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.cwe_pipeline_execution_policy.arn}"
}



resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.RESOURCE_PREFIX}-codebuild-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "arn:aws:s3:::codepipeline-${var.AWS_REGION}-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codecommit:GitPull"
        ],
        Resource = [
          "arn:aws:codecommit:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:${var.REPOSITORY_NAME}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource = [
          "arn:aws:codebuild:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:report-group/${var.CODEBUILD_VALIDATE_NAME}*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudformation:*",
          "sns:*",
          "s3:*",
          "codebuild:*",
          "codepipeline:*",
          "dynamodb:*"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "*"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = "${var.CODEBUILD_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
}



resource "aws_iam_policy" "codebuild_deploy_policy" {
  name = "${var.RESOURCE_PREFIX}-codebuild-deploy-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "arn:aws:s3:::codepipeline-${var.AWS_REGION}-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codecommit:GitPull"
        ],
        Resource = [
          "arn:aws:codecommit:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:${var.REPOSITORY_NAME}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource = [
          "arn:aws:codebuild:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:report-group/${var.CODEBUILD_DEPLOY_NAME}*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudformation:*",
          "sns:*",
          "s3:*",
          "codebuild:*",
          "codepipeline:*",
          "dynamodb:*"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "*"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_deploy_policy_attachment" {
  role       = "${var.CODEBUILD_DEPLOY_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.codebuild_deploy_policy.arn}"
}



resource "aws_iam_policy" "codepipeline_policy" {
  name = "${var.RESOURCE_PREFIX}-codepipeline-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = "*",
        Condition = {
          StringEqualsIfExists = {
            "iam:PassedToService" = [
              "cloudformation.amazonaws.com",
              "elasticbeanstalk.amazonaws.com",
              "ec2.amazonaws.com",
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "appconfig:StartDeployment",
          "appconfig:StopDeployment",
          "appconfig:GetDeployment"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "states:DescribeExecution",
          "states:DescribeStateMachine",
          "states:StartExecution"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:DescribeImages"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "cloudformation:ValidateTemplate"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "servicecatalog:ListProvisioningArtifacts",
          "servicecatalog:CreateProvisioningArtifact",
          "servicecatalog:DescribeProvisioningArtifact",
          "servicecatalog:DeleteProvisioningArtifact",
          "servicecatalog:UpdateProduct"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "devicefarm:ListProjects",
          "devicefarm:ListDevicePools",
          "devicefarm:GetRun",
          "devicefarm:GetUpload",
          "devicefarm:CreateUpload",
          "devicefarm:ScheduleRun"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:SetStackPolicy",
          "cloudformation:ValidateTemplate"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "opsworks:CreateDeployment",
          "opsworks:DescribeApps",
          "opsworks:DescribeCommands",
          "opsworks:DescribeDeployments",
          "opsworks:DescribeInstances",
          "opsworks:DescribeStacks",
          "opsworks:UpdateApp",
          "opsworks:UpdateStack"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction",
          "lambda:ListFunctions"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticbeanstalk:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "cloudformation:*",
          "rds:*",
          "sqs:*",
          "ecs:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codestar-connections:UseConnection"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetRepository",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = "${var.CODEPIPELINE_ROLE_NAME}"
  policy_arn = "${aws_iam_policy.codepipeline_policy.arn}"
}