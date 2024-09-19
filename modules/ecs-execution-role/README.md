# ECS Task Execution Role submodule

This submodule help create an IAM assumable role for ECS Task Execution Role

**Deprecated** This submodule is deprecated from version 0.3.0 . Please use `execution-role` submodule.

## Usage

```hcl
module "task_execution_role" {
  source  = "rabiloo/ecs/aws//modules/ecs-execution-role"
  version = "~>0.2.3"

  name = "custom-ecs-execution-role"
  path = "/service-roles/"

  readable_kms_keys_arn = [
    "arn:aws:kms:<region>:<account_id>:key/1234abcd-12ab-34cd-56ef-1234567890ab",
  ]
  readable_secrets_arn = [
    "arn:aws:secretsmanager:<region>:<account_id>:secret:example-123456",
  ]

  tags = {
    Owner   = "user"
    Service = "app-name"
    Managed = "Terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_policy"></a> [policy](#module\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | ~>5.30.0 |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~>5.30.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the IAM role | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the IAM role | `string` | `"This is a customized role"` | no |
| <a name="input_path"></a> [path](#input\_path) | The path to the IAM role | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The permissions boundary of the IAM role | `string` | `""` | no |
| <a name="input_readable_kms_keys_arn"></a> [readable\_kms\_keys\_arn](#input\_readable\_kms\_keys\_arn) | The list KMS key\_id | `list(string)` | `[]` | no |
| <a name="input_readable_secrets_arn"></a> [readable\_secrets\_arn](#input\_readable\_secrets\_arn) | The list secret ARN | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The list of tags to apply to the IAM role | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The ARN of the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | The unique ID of the IAM role |
<!-- END_TF_DOCS -->

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged.
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/rabiloo/terraform-aws-ecs/issues).

## License

This project is released under the MIT License.
Copyright © 2024 [Rabiloo Co., Ltd](https://rabiloo.com)
Please see [License File](https://github.com/rabiloo/terraform-aws-ecs/blob/master/LICENSE) for more information.
