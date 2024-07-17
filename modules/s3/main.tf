resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.RESOURCE_PREFIX}-terraform-artifact-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}