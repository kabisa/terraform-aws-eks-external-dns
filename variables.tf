variable "region" {
  type        = string
  description = "The region that should be set in the external DNS container environment"
  default     = null
}

variable "oidc_host_path" {
  type        = string
  description = "OIDC url stripped of the \"https://\" part"
}

variable "account_id" {
  type        = string
  description = "The ID of the AWS account the roles should associated with"
  default     = null
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the chart to use. If not specified, will use the latest stable release"
  default     = null
}
