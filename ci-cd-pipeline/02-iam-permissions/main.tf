resource "aws_iam_role" "codepipeline-basic-role" {
  name                = var.codepipeline_role_name
  assume_role_policy  = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "CodepipelineAssumeRoleSpec"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
  
  inline_policy {
    name    = "codepipeline-inline-policy"
    policy  = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "codecommit:CancelUploadArchive",
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:UploadArchive"
          ]
          Resource=  "*"
        },
        {
          Effect = "Allow",
          Action = [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
          ],
          "Resource" = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "devicefarm:ListProjects",
            "devicefarm:ListDevicePools",
            "devicefarm:GetRun",
            "devicefarm:GetUpload",
            "devicefarm:CreateUpload",
            "devicefarm:ScheduleRun"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "lambda:InvokeFunction",
            "lambda:ListFunctions"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "iam:PassRole"
          ],
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "elasticbeanstalk:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "cloudwatch:*",
            "s3:*",
            "sns:*",
            "cloudformation:*",
            "rds:*",
            "sqs:*",
            "ecs:*"
          ],
          Resource = "*"
        }
      ]
    })
      
  }  
  tags = tomap(var.tags)
}


resource "aws_iam_role" "codebuild-service-role" {
  name                = var.codebuild_role_name
  assume_role_policy  = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "CodeBuildAssumeRoleSpec"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
  
  inline_policy {
    name    = "codebuild-inline-policy"
    policy  = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Resource  = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_name}",
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_name}:*"
          ],
          Action    = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          Effect    = "Allow",
          Resource  = [
            "arn:aws:s3:::${var.bucket_codepipeline_name}",
            "arn:aws:s3:::${var.bucket_codepipeline_name}/*"
          ],
          Action    = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          Effect    = "Allow",
          Action    = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          Resource  = [
            "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/${var.codebuild_name}-*"
          ]
        },
        {
          Effect    = "Allow",
          Action    = [
            "kms:Decrypt",
            "kms:GenerateDataKey"
          ],
          Resource  = [
            "${var.kms_arn}"
          ]
        }
      ]
    })
  }

  tags = tomap(var.tags)
}

resource "aws_iam_role" "codedeploy_service_role" {
  name = var.codedeploy_role_name
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "CodeDeployAssumeRoleSpec"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [ 
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  ]

  tags = tomap(var.tags)
}