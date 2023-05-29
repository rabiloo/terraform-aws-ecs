# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
# When you register a task definition, you can provide a task role for an IAM role
# that allows the containers in the task permission to call the AWS APIs that are specified
# in its associated policies on your behalf.
# It includes the following permissions:
# - allow ecs exec command
# - get files from S3
# - put files to S3
# - send email messages via Amazon SES
# - sends application logs to CloudWatch Logs

locals {
  s3_arns = compact(distinct(concat(var.writable_s3_arns, var.readable_s3_arns)))
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "AllowEcsExec"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(local.s3_arns) > 0 ? [true] : []

    content {
      sid    = "AllowListBucket"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
      ]
      resources = local.s3_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.writable_s3_arns) > 0 ? [true] : []

    content {
      sid    = "AllowS3ObjectActions"
      effect = "Allow"
      actions = [
        "s3:*Object*",
      ]
      resources = [for arn in var.writable_s3_arns : "${arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = length(var.readable_s3_arns) > 0 ? [true] : []

    content {
      sid    = "AllowS3ReadOnly"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetObjectAcl",
        "s3:GetObjectVersionAcl",
      ]
      resources = [for arn in var.readable_s3_arns : "${arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = length(var.sendable_ses_arns) > 0 ? [true] : []

    content {
      sid    = "AllowSendMail"
      effect = "Allow"
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail",
      ]
      resources = var.sendable_ses_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.writable_log_group_arns) > 0 ? [true] : []

    content {
      sid    = "AllowWriteLogs"
      effect = "Allow"
      actions = [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ]
      resources = [for arn in var.writable_log_group_arns : "${arn}/*"]
    }
  }
}

module "policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~>5.20.0"

  name   = "${var.name}-policies"
  policy = data.aws_iam_policy_document.policy.json
  tags   = var.tags
}

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~>5.20.0"

  role_name        = var.name
  role_path        = var.path
  role_description = var.description
  tags             = var.tags

  create_role       = true
  role_requires_mfa = false

  trusted_role_actions = [
    "sts:AssumeRole",
  ]
  trusted_role_services = [
    "ecs-tasks.amazonaws.com",
  ]

  custom_role_policy_arns = [
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
    module.policy.arn,
  ]

  depends_on = [
    module.policy,
  ]
}
