output "iam_role_unique_id" {
  description = "The unique ID of the IAM role"
  value       = module.this.iam_role_unique_id
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.this.iam_role_name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = module.this.iam_role_arn
}
