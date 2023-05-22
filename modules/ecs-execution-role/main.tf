# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
# The task execution role grants the Amazon ECS container and Fargate agents permission
# to make AWS API calls on your behalf.
# It includes the following permissions:
# - pulling a container image from an Amazon ECR private repository
# - sends container logs to CloudWatch Logs using the awslogs log driver
# - using private registry authentication
# - referencing sensitive data using Secrets Manager secrets or AWS Systems Manager Parameter Store parameters

data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "policy" {
  // TODO: test this statement is required?
  statement {
    sid    = "AllowECSExecCommand"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  # statement {
  #   sid = "AllowGetSecrets"
  #   effect = "Allow"
  #   actions = [
  #     "kms:Decrypt",
  #     "secretsmanager:GetSecretValue"
  #   ]
  #   resources = [
  #     "arn:aws:secretsmanager:<region>:<aws_account_id>:secret:secret_name",
  #     "arn:aws:kms:<region>:<aws_account_id>:key/key_id"
  #   ]
  # }

  dynamic "statement" {
    for_each = (length(var.readable_kms_keys_arn) > 0 && length(var.readable_secrets_arn) > 0) ? [true] : []
    content {
      sid    = "AllowGetSecrets"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "secretsmanager:GetSecretValue",
      ]
      resources = concat(
        var.readable_kms_keys_arn,
        var.readable_secrets_arn,
      )
    }
  }
}

module "policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~>5.19.0"

  name   = "${var.name}-policies"
  policy = data.aws_iam_policy_document.policy.json
  tags   = var.tags
}

module "this" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~>5.19.0"

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
    "ecs.amazonaws.com",
    "ecs-tasks.amazonaws.com",
  ]
  custom_role_policy_arns = [
    data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn,
    module.policy.arn,
  ]

  depends_on = [
    module.policy,
  ]
}
