data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "encryption_kms_key" {
  description = var.tags.Description
  enable_key_rotation = true
  policy = data.aws_iam_policy_document.kms_key_policy_doc.json
  tags = tomap(var.tags)
}

data "aws_iam_policy_document" "kms_key_policy_doc" {
  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"
    actions = [ "kms:*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::${local.account_id}:root" ]
    }
  }

  statement {
    sid       = "Allow access for Key Administrators"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        var.codepipeline_role_arn
      ]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        var.codepipeline_role_arn
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        var.codepipeline_role_arn
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}
resource "aws_kms_alias" "alias_kms_key" {
  name          = var.tags.Name
  target_key_id = aws_kms_key.encryption_kms_key.id
}