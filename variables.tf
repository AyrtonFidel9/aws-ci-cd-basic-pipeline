variable "aws_region" {}
variable "aws_profile" {}

variable "s3_bucket_name_pipeline" {
  description = "Bucket name to store artifacts generated by the pipeline"
}

variable "kms_key_name" {
  description = "KMS key name"
}

variable "codedeploy_name" {
  description = "codedeploy name"
}

variable "codepipeline_name" {
  description = "Codepipeline name"
}

variable "codebuild_name" {
  description = "codebuild name"
}

variable "build_project_source" {
  description = "codebuild name"
}

variable "builder_compute_type" {
  description = "codebuild name"
}

variable "builder_image" {
  description = "codebuild name"
}

variable "builder_type" {
  description = "codebuild name"
}

variable "codecommit_repo_name" {
  description = "codecommit repository name"
}

variable "codecommit_repo_branch" {
  description = "codecommit repository branch to track"
}

variable "pipeline_stage_build_name" {
  description = "stage build name"
}

variable "pipeline_stage_deploy_name" {
  description = "stage deploy name"
}

variable "artifact_identifier" {
  description = "artifact identifier"
}

variable "execution_mode" {
  description = "execution mode type for codepipeline"
}

variable "version_pipeline" {
  description = "version type for codepipeline"
}

# Variable Tags
variable "environment" {
  description = "Describe the kind of environment in that the resources will be used (dev|uat|prod)"
}

variable "created_by" {
  description = "Person who created the resource"
}

variable "application" {
  description = "The service or application of which the resource is a component"
}

variable "cost_center" {
  description = "Useful for billing center (Human Resources | IT department)"
}

variable "contact" {
  description = "email address for the team or individual"
}

variable "maintenance_window" {
  description = "Useful for defining a window of time that resource is allows to not be available in case of parching, updates, or maintance"
}

variable "deletion_date" {
  description = "Useful for development or sandbox environments so that you know when it may be safe to delete a resource"
}