variable "s3_bucket_name_pipeline" {
  description = "S3 bucket name"
  type = string
}

variable "kms_key_arn" {
  description = "kms key arn"
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}