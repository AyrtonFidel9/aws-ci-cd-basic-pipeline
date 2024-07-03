variable "name" {
  description = "codepipeline name"
  type = string
}

variable "iam_codepipeline_arn" {
  description = "codepipeline iam service role arn"
  type = string
}

variable "s3_bucket_codepipeline" {
  description = "codepipeline s3 bucket"
  type = string
}

variable "kms_arn_s3_bucket" {
  description = "kms key used on s3 bucket"
  type = string
}

variable "aws_codecommit_repo_id"{
  description = "codecommit repository name"
  type = string
}

variable "aws_codecommit_repo_branch"{
  description = "codecommit repository branch"
  type = string
}

variable "name_stage_build" {
  description = "codepipeline stage build name"
  type = string
}

variable "codebuild_name" {
  description = "codebuild project name"
  type = string
}

variable "name_stage_deploy" {
  description = "codepipeline stage deploy name"
  type = string
}

variable "codedeploy_app_name" {
  description = "codedeploy app name"
  type = string
}

variable "codedeploy_deployment_group_name" {
  description = "codedeploy deployment group name"
  type = string
}

variable "execution_mode" {
  description = "codepipeline execution mode"
  type = string
}

variable "version_pipeline" {
  description = "codepipeline version"
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}