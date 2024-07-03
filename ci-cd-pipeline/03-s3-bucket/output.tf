output "s3bucket_arn" {
  value = aws_s3_bucket.codepipeline-bucket-s3.arn
}

output "s3bucket_name" {
  value = aws_s3_bucket.codepipeline-bucket-s3.bucket
}


output "s3bucket_key_arn" {
  value = aws_s3_bucket.codepipeline-bucket-s3.arn
}

