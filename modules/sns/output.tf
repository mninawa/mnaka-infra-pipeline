output "REPO_TRIGGER_SNS_TOPIC_ARN" {
  value = "${aws_sns_topic.repo_trigger.arn}"
}