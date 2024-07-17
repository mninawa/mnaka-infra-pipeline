resource "aws_cloudwatch_event_rule" "pipeline_deploy_cw_event_rule" {
  name        = "${var.RESOURCE_PREFIX}-pipeline-deploy-cw-event-rule"
  event_pattern = <<PATTERN
  {
    "source": [
      "aws.codecommit"
    ],
    "detail-type": [
      "CodeCommit Repository State Change"
    ],
    "resources": [
      "arn:aws:codecommit:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:${var.REPOSITORY_NAME}"
    ],
    "detail": {
      "event": [
        "referenceCreated",
        "referenceUpdated"
      ],
      "referenceType": [
        "branch"
      ],
      "referenceName":[
        "master"
      ]
    }
  }
  PATTERN 
}
# iam.amazonaws.com

resource "aws_cloudwatch_event_target" "yada" {
  rule      = aws_cloudwatch_event_rule.pipeline_deploy_cw_event_rule.name
  arn       = "arn:aws:codepipeline:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:${var.CODE_PIPELINE_NAME}"
  role_arn = var.CLOUD_WATCH_EVENT_ROLE_ARN
}