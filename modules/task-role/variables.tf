variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "TheA map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the IAM role"
  type        = string

  validation {
    condition     = var.name != ""
    error_message = "The name MUST be not empty."
  }

  validation {
    condition     = var.name == replace(var.name, "/[^a-zA-Z0-9-_]+/", "")
    error_message = "The name MUST be alphanumeric and can contain dashes and underscores."
  }
}

variable "use_name_prefix" {
  description = "Determines whether the IAM role name is used as a prefix"
  type        = bool
  default     = true
}

variable "path" {
  description = "The path to the IAM role"
  type        = string
  default     = "/"

  validation {
    condition     = var.path == replace(var.path, "/[^a-zA-Z0-9-_\\/]+/", "")
    error_message = "The path MUST be alphanumeric and can contain dashes, underscores and slashs."
  }
}

variable "description" {
  description = "The description of the IAM role"
  type        = string
  default     = null
}

variable "permissions_boundary_arn" {
  description = "The permissions boundary of the IAM role"
  type        = string
  default     = null
}

variable "policy_arns" {
  description = "The list of IAM policy ARN be attached to IAM role"
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = false
}
