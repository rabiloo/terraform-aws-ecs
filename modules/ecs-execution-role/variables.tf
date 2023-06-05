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

variable "tags" {
  description = "The list of tags to apply to the IAM role"
  type        = map(string)
  default     = {}
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
  default     = "This is a customized role"
}

variable "readable_kms_keys_arn" {
  description = "The list KMS key_id"
  type        = list(string)
  default     = []
}

variable "readable_secrets_arn" {
  description = "The list secret ARN"
  type        = list(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "The permissions boundary of the IAM role"
  type        = string
  default     = ""
}
