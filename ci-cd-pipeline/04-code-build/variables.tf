variable "codebuild_name" {
  description = "Codebuild name"
  type = string
}

variable "codebuild_service_role_arn" {
  description = "Codebuild service role arn"
  type = string
}

variable "encryption_key_arn" {
  description = "KMS key encryption arn"
  type = string
}

variable "builder_compute_type" {
  description = "Compute type to perform building"
  type = string
}

variable "builder_image" {
  description = "Image name that codebuild will use"
  type = string
}

variable "builder_type" {
  description = "Builder type"
  type = string
}

variable "build_project_source" {
  description = "Build project source"
  type = string
}

variable "s3_bucket_codepipeline" {
  description = "S3 bucket name to codepipeline"
  type = string
}

variable "artifact_identifier" {
  description = "artifact identifier"
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}
