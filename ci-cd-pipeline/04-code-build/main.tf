resource "aws_codebuild_project" "codebuild" {
  name            = var.codebuild_name
  service_role    = var.codebuild_service_role_arn
  encryption_key  = var.encryption_key_arn

  artifacts {
    type                = var.build_project_source
    artifact_identifier = var.artifact_identifier
    location            = var.s3_bucket_codepipeline
    packaging           = "ZIP"
  }
  
  environment {
    compute_type                    = var.builder_compute_type
    image                           = var.builder_image
    type                            = var.builder_type
    privileged_mode                 = false
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type = var.build_project_source
  }

  tags = tomap(var.tags)
}