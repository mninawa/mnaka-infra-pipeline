output "CODEPIPELINE_BUCKET" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}