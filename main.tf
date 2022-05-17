locals {
  account_id = coalesce(var.account_id, data.aws_caller_identity.current.account_id)
  region     = coalesce(var.region, data.aws_region.current.name)
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.helm_chart_version

  values = [
    templatefile(
      "${path.module}/yamls/external-dns-values.yaml",
      {
        region       = var.region
        aws_role_arn = aws_iam_role.external_dns.arn
      }
    )
  ]
}

