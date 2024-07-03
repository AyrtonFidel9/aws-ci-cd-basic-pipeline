variable "codepipeline_role_arn" {
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}