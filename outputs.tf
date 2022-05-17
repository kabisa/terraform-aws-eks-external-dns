output "role_name" {
  value       = join("", aws_iam_role.external_dns.*.name)
  description = "The name of the IAM role created"
}

output "role_id" {
  value       = join("", aws_iam_role.external_dns.*.unique_id)
  description = "The stable and unique string identifying the role"
}

output "role_arn" {
  value       = join("", aws_iam_role.external_dns.*.arn)
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "role_policy" {
  value       = join("", data.aws_iam_policy_document.external_dns.*.json)
  description = "Role policy document in json format"
}

output "helm_metadata" {
  value       = join("", helm_release.external_dns.*.metadata)
  description = "Metadata from the Helm release"
}
