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

variable "permissions_boundary_arn" {
  description = "The permissions boundary of the IAM role"
  type        = string
  default     = ""
}

variable "custom_policy_document_json" {
  description = "The custom document json for createing an IAM policy"
  type        = string
  default     = ""
}

variable "enable_ssm_core_policy" {
  description = "Enable to attach AmazonSSMManagedInstanceCore to task role"
  type        = bool
  default     = true
}

variable "writable_s3_arns" {
  description = "The list of S3 ARN that can be written to"
  type        = list(string)
  default     = ["arn:aws:s3:::*"]
}

variable "readable_s3_arns" {
  description = "The list of S3 ARN that can be read from"
  type        = list(string)
  default     = ["arn:aws:s3:::*"]
}

variable "sendable_ses_arns" {
  description = "The list of SES domain identity ARN that can be sent from"
  type        = list(string)
  default     = ["arn:aws:ses:*:*:*"]
}

variable "writable_log_group_arns" {
  description = "The list of Log group ARN that can be written to"
  type        = list(string)
  default     = ["arn:aws:logs:::*"]
}
