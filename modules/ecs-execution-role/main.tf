# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
# The task execution role grants the Amazon ECS container and Fargate agents permission
# to make AWS API calls on your behalf.
# It includes the following permissions:
# - pulling a container image from an Amazon ECR private repository
# - sends container logs to CloudWatch Logs using the awslogs log driver
# - using private registry authentication
# - referencing sensitive data using Secrets Manager secrets or AWS Systems Manager Parameter Store parameters

locals {
  ecs_task_execution_role_policy_arn = "arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "AllowLoginECR"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = "*"
  }

  dynamic "statement" {
    for_each = length(var.readable_kms_keys_arn) > 0 ? [true] : []
    content {
      sid    = "AllowDecryptSecrets"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
      ]
      resources = var.readable_kms_keys_arn
    }
  }

  dynamic "statement" {
    for_each = length(var.readable_secrets_arn) > 0 ? [true] : []
    content {
      sid    = "AllowGetSecrets"
      effect = "Allow"
      actions = [
        "secretsmanager:GetSecretValue",
      ]
      resources = var.readable_secrets_arn
    }
  }
}

module "policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~>5.30.0"

  name   = "${var.name}-policies"
  policy = data.aws_iam_policy_document.policy.json
  tags   = var.tags
}

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~>5.30.0"

  role_name        = var.name
  role_path        = var.path
  role_description = var.description
  tags             = var.tags

  create_role                   = true
  role_requires_mfa             = false
  role_permissions_boundary_arn = var.permissions_boundary_arn

  trusted_role_actions = [
    "sts:AssumeRole",
  ]
  trusted_role_services = [
    "ecs-tasks.amazonaws.com",
  ]
  custom_role_policy_arns = [
    local.ecs_task_execution_role_policy_arn,
    module.policy.arn,
  ]

  depends_on = [
    module.policy,
  ]
}
