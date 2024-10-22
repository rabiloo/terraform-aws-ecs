# ECS Task Role submodule

This submodule help create an IAM assumable role for ECS Task

**Deprecated** This submodule is deprecated from version 0.3.0 . Please use `task-role` submodule.

## Usage

```hcl
module "task_role" {
  source  = "rabiloo/ecs/aws//modules/ecs-task-role"
  version = "~>0.2.3"

  name = "custom-ecs-task-role"
  path = "/service-roles/"

  writable_s3_arns = [
    "arn:aws:s3:::app-media-upload-bucket",
    "arn:aws:s3:::app-media-resized-bucket",
  ]
  readable_s3_arns = [
    "arn:aws:s3:::app-config-bucket",
    "arn:aws:s3:::app-template-bucket",
  ]
  sendable_ses_arns = []
  writable_log_group_arns = [
    "arn:aws:logs:<region>:<account_id>:log-group:app-access-log-xxxx:*",
    "arn:aws:logs:<region>:<account_id>:log-group:app-error-log-xxxx:*",
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
| <a name="module_policy"></a> [policy](#module\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | ~>5.33.0 |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~>5.33.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the IAM role | `string` | n/a | yes |
| <a name="input_custom_policy_document_json"></a> [custom\_policy\_document\_json](#input\_custom\_policy\_document\_json) | The custom document json for createing an IAM policy | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the IAM role | `string` | `"This is a customized role"` | no |
| <a name="input_enable_ssm_core_policy"></a> [enable\_ssm\_core\_policy](#input\_enable\_ssm\_core\_policy) | Enable to attach AmazonSSMManagedInstanceCore to task role | `bool` | `true` | no |
| <a name="input_path"></a> [path](#input\_path) | The path to the IAM role | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The permissions boundary of the IAM role | `string` | `""` | no |
| <a name="input_readable_s3_arns"></a> [readable\_s3\_arns](#input\_readable\_s3\_arns) | The list of S3 ARN that can be read from | `list(string)` | <pre>[<br/>  "arn:aws:s3:::*"<br/>]</pre> | no |
| <a name="input_sendable_ses_arns"></a> [sendable\_ses\_arns](#input\_sendable\_ses\_arns) | The list of SES domain identity ARN that can be sent from | `list(string)` | <pre>[<br/>  "arn:aws:ses:*:*:*"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The list of tags to apply to the IAM role | `map(string)` | `{}` | no |
| <a name="input_writable_log_group_arns"></a> [writable\_log\_group\_arns](#input\_writable\_log\_group\_arns) | The list of Log group ARN that can be written to | `list(string)` | <pre>[<br/>  "arn:aws:logs:::*"<br/>]</pre> | no |
| <a name="input_writable_s3_arns"></a> [writable\_s3\_arns](#input\_writable\_s3\_arns) | The list of S3 ARN that can be written to | `list(string)` | <pre>[<br/>  "arn:aws:s3:::*"<br/>]</pre> | no |

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
