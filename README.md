# AWS ECS Terraform module

Terraform module which creates ECS cluster resources on AWS.

## TODO

- [ ] Update README.md
- [ ] Add examples
- [ ] Add Github Wrokflows

## Usage

```hcl
module "php" {
  source  = "rabiloo/ecs/aws"
  version = "~> 0.1.0"

  name = "app-ecs-cluster"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    { capacity_provider = "FARGATE" },
  ]
  tags = {
    Owner       = "user"
    Service     = "app-name"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| Terraform | `~> 1.0` |

## Providers

| Name | Version |
|------|---------|
| aws  | `~> 3.52` |

## Resources



## Inputs

## Outputs

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged. 
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/rabiloo/terraform-aws-ecs/issues).

## License

This project is released under the MIT License.   
Copyright © 2021 [Rabiloo Co., Ltd](https://rabiloo.com)   
Please see [License File](LICENSE) for more information.
