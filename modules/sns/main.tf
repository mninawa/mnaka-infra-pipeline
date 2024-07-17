resource "aws_sns_topic" "repo_trigger" {
  name = "${var.RESOURCE_PREFIX}-repo-trigger"
}