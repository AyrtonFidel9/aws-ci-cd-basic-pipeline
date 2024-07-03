resource "aws_codepipeline" "pipeline-basic" {
  name            = var.name
  role_arn        = var.iam_codepipeline_arn
  execution_mode  = var.execution_mode //"QUEUED"
  pipeline_type   = var.version_pipeline //"V2"

  artifact_store {
    location = var.s3_bucket_codepipeline
    type = "S3"
    encryption_key {
      id   = var.kms_arn_s3_bucket
      type = "KMS"
    }
  }

  // Stage to add CodeCommit in the initial stage  as repository where code is located
  stage {
    name = "SourceRepository"
    action {
      name              = "SourceCodeCommitInit"
      category          = "Source"
      owner             = "AWS"
      provider          = "CodeCommit"
      version           = "1"
      output_artifacts  = [ "SourceOutput" ]
      run_order         = 1

      configuration = {
        RepositoryName        = var.aws_codecommit_repo_id
        BranchName            = var.aws_codecommit_repo_branch
        PollForSourceChanges  = "false"
      }
    }
  }

  // Stage to build all dependencies
  stage {
    name = "Build"

    action {
      name              = var.name_stage_build
      category          = "Build" 
      owner             = "AWS"
      provider          = "CodeBuild"
      input_artifacts   = [ "SourceOutput" ] 
      output_artifacts  = [ "BuildOutput" ]
      version           = "1"
      configuration = {
        ProjectName = var.codebuild_name
        PrimarySource = "SourceOutput"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = var.name_stage_deploy
      provider = "CodeDeploy"
      category = "Deploy"
      owner = "AWS"
      input_artifacts = [ "BuildOutput" ]
      version = "1"

      configuration = {
        ApplicationName = var.codedeploy_app_name
        DeploymentGroupName = var.codedeploy_deployment_group_name
      }

    } 
  }

  tags = tomap(var.tags)
}

// Fragment to create an EVentBridge rule that detect repository changes to trigger the aws codepipeline
data "aws_codecommit_repository" "commit_repo" {
  repository_name = "${var.aws_codecommit_repo_id}"
}

locals {
  commit_repo_arn = data.aws_codecommit_repository.commit_repo.arn
}

resource "aws_cloudwatch_event_rule" "codecommit_cwe" {
  name_prefix = "${var.aws_codecommit_repo_id}-${var.aws_codecommit_repo_branch}-cwe"
  description = "Detect commits to CodeCommit repo of ${var.aws_codecommit_repo_id} on branch ${var.aws_codecommit_repo_branch}"

  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": [ "${local.commit_repo_arn}"],
  "detail": {
     "event": [
       "referenceCreated",
       "referenceUpdated"
      ],
     "referenceType":["branch"],
     "referenceName": ["${var.aws_codecommit_repo_branch}"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch_triggers_pipeline" {
  target_id = "${var.aws_codecommit_repo_branch}-commits-trigger-pipeline"
  rule = aws_cloudwatch_event_rule.codecommit_cwe.name
  arn = aws_codepipeline.pipeline-basic.arn
  role_arn = aws_iam_role.cloudwatch_ci_role.arn
}

# Allows the CloudWatch event to assume roles
resource "aws_iam_role" "cloudwatch_ci_role" {
  name_prefix = "${var.aws_codecommit_repo_branch}-cw-ci-"

  assume_role_policy = <<DOC
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  DOC
}

data "aws_iam_policy_document" "cloudwatch_ci_iam_policy" {
  statement {
    actions = ["iam:PassRole"]
    resources = ["*"]
  }
  statement {
    actions = ["codepipeline:StartPipelineExecution"]
    resources = [aws_codepipeline.pipeline-basic.arn]
  }
}

resource "aws_iam_policy" "cloudwatch_ci_iam_policy" {
  name_prefix = "${var.aws_codecommit_repo_branch}-cw-ci-"
  policy = data.aws_iam_policy_document.cloudwatch_ci_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_ci_iam" {
  policy_arn = aws_iam_policy.cloudwatch_ci_iam_policy.arn
  role = aws_iam_role.cloudwatch_ci_role.name
}