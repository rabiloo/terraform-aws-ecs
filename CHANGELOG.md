# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.3.1...master)

### Added

- Nothing

### Changed

- Nothing

### Deprecated

- Nothing

### Removed

- Nothing

### Fixed

- Nothing

### Security

- Nothing

<!-- New Release notes will be placed here automatically -->
## [v0.3.1](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.3.0...v0.3.1) - 2024-10-22

### Updated

- Add some feature to make custom policy statement
- Change `aws_iam_role_policy` resource  to `aws_iam_policy` and `aws_iam_role_policy_attachment` resources

**Full Changelog**: https://github.com/rabiloo/terraform-aws-ecs/compare/v0.3.0...v0.3.1

## [v0.3.0](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.2.3...v0.3.0) - 2024-09-19

### Added

- Add submodule `execution-role`
- Add submodule `task-role`

### Updated

- Update dependabot config
- Update Github Workflow

### Deprecated

- Deprecated module `rabiloo/ecs/aws`
- Deprecated submodule `rabiloo/ecs/aws//modules/ecs-execution-role`
- Deprecated submodule `rabiloo/ecs/aws//modules/ecs-task-role`

## [v0.2.3](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.2.2...v0.2.3) - 2023-06-06

### Fixed

- Fix deprecated `capacity_providers` and `default_capacity_provider_strategy` arguments of `aws_ecs_cluster` resource

## [v0.2.2](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.2.1...v0.2.2) - 2023-06-05

### Added

- Add `permissions_boundary_arn` variable

## [v0.2.1](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.2.0...v0.2.1) - 2023-04-02

### Add

- Submodule `ecs-execution-role`
- Submodule `ecs-task-role`

### Change

- Update required AWS provider version to `>=4.0`

## [v0.2.0](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.1.1...v0.2.0) - 2023-01-30

### Changed

- Required AWS provider version `~>4.52`

## [v0.1.1](https://github.com/rabiloo/terraform-aws-ecs/compare/v0.1.0...v0.1.1) - 2021-08-25

### Added

- Add Lint action for push and pull request to master branch
- Add Makefile
- Add documents for inputs and outputs

### Fixed

- Fix bug validation of `name` variable

## v0.1.0 - 2021-08-10

### Added

- Initial Release
