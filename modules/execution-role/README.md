# ECS Task Execution Role submodule

This submodule help create an IAM assumable role for ECS Task Execution Role

## Usage

```hcl
module "task_execution_role" {
  source  = "rabiloo/ecs/aws//modules/ecs-execution-role"
  version = "~>0.3.1"

  name = "custom-ecs-execution-role"
  path = "/service-roles/"
  tags = {
    Owner   = "user"
    Service = "app-name"
    Managed = "Terraform"
  }

  enable_write_log_streams = true
  enable_pull_ecr_images   = true
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the IAM role | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the IAM role | `string` | `null` | no |
| <a name="input_enable_pull_ecr_images"></a> [enable\_pull\_ecr\_images](#input\_enable\_pull\_ecr\_images) | Controls if the task execution role will be permitted to pull ECR private repositories | `bool` | `false` | no |
| <a name="input_enable_read_secrets"></a> [enable\_read\_secrets](#input\_enable\_read\_secrets) | Controls if the task execution role will be permitted to get/read SecretsManager secrets | `bool` | `false` | no |
| <a name="input_enable_read_ssm_params"></a> [enable\_read\_ssm\_params](#input\_enable\_read\_ssm\_params) | Controls if the task execution role will be permitted to get/read SSM parameters | `bool` | `false` | no |
| <a name="input_enable_write_log_streams"></a> [enable\_write\_log\_streams](#input\_enable\_write\_log\_streams) | Controls if the task execution role will be permitted to put/write CloudWatch log streams | `bool` | `false` | no |
| <a name="input_path"></a> [path](#input\_path) | The path to the IAM role | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The permissions boundary of the IAM role | `string` | `null` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | The list of IAM policy ARN be attached to IAM role | `map(string)` | `{}` | no |
| <a name="input_pullable_ecr_images"></a> [pullable\_ecr\_images](#input\_pullable\_ecr\_images) | List of ECR private repositories the task execution role will be permitted to pull | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_readable_secrets"></a> [readable\_secrets](#input\_readable\_secrets) | List of SecretsManager secret ARNs the task execution role will be permitted to get/read | `list(string)` | <pre>[<br/>  "arn:aws:secretsmanager:*:*:secret:*"<br/>]</pre> | no |
| <a name="input_readable_ssm_params"></a> [readable\_ssm\_params](#input\_readable\_ssm\_params) | List of SSM parameter ARNs the task execution role will be permitted to get/read | `list(string)` | <pre>[<br/>  "arn:aws:ssm:*:*:parameter/*"<br/>]</pre> | no |
| <a name="input_statements"></a> [statements](#input\_statements) | A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | TheA map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | Determines whether the IAM role name is used as a prefix | `bool` | `true` | no |
| <a name="input_writable_log_streams"></a> [writable\_log\_streams](#input\_writable\_log\_streams) | List of CloudWatch log streams the task execution role will be permitted to put/write | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The ARN of the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
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
