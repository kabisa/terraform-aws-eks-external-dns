locals {
  enabled = module.this.enabled

  account_id = coalesce(var.account_id, data.aws_caller_identity.current[0].account_id)
  region     = coalesce(var.region, data.aws_region.current[0].name)
}

data "aws_caller_identity" "current" {
  count = local.enabled ? 1 : 0
}
data "aws_region" "current" {
  count = local.enabled ? 1 : 0
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["external", "dns"]

  context = module.this.context
}
resource "helm_release" "external_dns" {
  count      = local.enabled ? 1 : 0
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.helm_chart_version

  values = flatten([
    templatefile(
      "${path.module}/yamls/external-dns-values.yaml",
      {
        region       = local.region
        aws_role_arn = aws_iam_role.external_dns[0].arn
      }
    ),
    var.helm_value_files
  ])
}
