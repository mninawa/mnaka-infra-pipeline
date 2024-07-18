

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.RESOURCE_PREFIX}-terraform-artifact-bucket"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  depends_on = [
	aws_s3_bucket_public_access_block.codepipeline_bucket,
	aws_s3_bucket_ownership_controls.codepipeline_bucket,
  ]

  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}



# resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }