################################################################################
# Task Execution - IAM Role
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
################################################################################

locals {
  name_prefix = "${trimsuffix(var.name)}-"

  create_custom_policy = var.create && (length(var.statements) > 0 || var.enable_read_ssm_params || var.enable_read_secrets || var.enable_write_log_streams || var.enable_pull_ecr_images)
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create ? 1 : 0

  statement {
    sid     = "ECSTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
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
  count = local.create_custom_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.enable_write_log_streams ? [1] : []

    content {
      sid = "WriteLogs"
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
      resources = var.writable_log_streams
    }
  }

  dynamic "statement" {
    for_each = var.enable_pull_ecr_images ? [1] : []

    content {
      sid = "GetECRToken"
      actions = [
        "ecr:GetAuthorizationToken",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.enable_pull_ecr_images ? [1] : []

    content {
      sid = "PullECRImages"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
      ]
      resources = var.pullable_ecr_images
    }
  }

  dynamic "statement" {
    for_each = var.enable_read_ssm_params ? [1] : []

    content {
      sid       = "GetSSMParams"
      actions   = ["ssm:GetParameters"]
      resources = var.readable_ssm_params
    }
  }

  dynamic "statement" {
    for_each = var.enable_read_secrets ? [1] : []

    content {
      sid       = "GetSecrets"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.readable_secrets
    }
  }

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

resource "aws_iam_policy" "custom" {
  count = local.create_custom_policy ? 1 : 0

  name        = var.use_name_prefix ? null : var.name
  name_prefix = var.use_name_prefix ? local.name_prefix : null
  policy      = data.aws_iam_policy_document.custom[0].json
  description = "Task execution role IAM policy"
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = local.create_custom_policy ? 1 : 0

  role       = aws_iam_role.this[0].id
  policy_arn = aws_iam_policy.custom[0].arn
}
