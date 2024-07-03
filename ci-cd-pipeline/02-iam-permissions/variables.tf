variable "codepipeline_role_name" {
  description = "Name for the codepipeline role"
  type = string
}

variable "codebuild_role_name" {
  description = "Name for the codebuild role"
  type = string
}

variable "codedeploy_role_name" {
  description = "Name for the codedeploy role"
  type = string
}

variable "bucket_codepipeline_name" {
  description = "Name of the codepipeline s3 bucket"
  type = string
}

variable "kms_arn" {
  description = "KMS key arn"
  type = string
}

variable "codebuild_name" {
  description = "Name of the codebuild"
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}