resource "aws_s3_bucket" "codepipeline-bucket-s3" {
  bucket  = var.s3_bucket_name_pipeline
  tags    = tomap(var.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = aws_s3_bucket.codepipeline-bucket-s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}