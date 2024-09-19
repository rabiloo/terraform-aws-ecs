################################################################################
# Tasks - IAM role
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
################################################################################

data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  partition   = data.aws_partition.current.partition
  region      = data.aws_region.current.name
  name_prefix = "${trimsuffix(var.name)}-"

  create_custom_policy = var.create && length(var.statements) > 0
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create ? 1 : 0

  statement {
    sid     = "ECSTasksAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html#create_task_iam_policy_and_role
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:ecs:${local.region}:${local.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name        = var.use_name_prefix ? null : var.name
  name_prefix = var.use_name_prefix ? local.name_prefix : null
  path        = var.path
  description = var.description

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.policy_arns : k => v if var.create }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

data "aws_iam_policy_document" "custom" {
  count = var.create && length(var.statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.statements

    content {
      sid           = try(statement.value.sid, statement.key)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_role_policy" "custom" {
  count = local.create_custom_policy ? 1 : 0

  name        = var.use_name_prefix ? null : var.name
  name_prefix = var.use_name_prefix ? local.name_prefix : null
  policy      = data.aws_iam_policy_document.custom[0].json
  role        = aws_iam_role.this[0].id
}
