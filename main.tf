resource "helm_release" "external-dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.11.3"
  # appVersion: 0.12.2

  values = [
    templatefile(
      "${path.module}/yamls/external-dns-values.yaml",
      {
        region       = var.region
        aws_role_arn = aws_iam_role.external-dns-iam-role.arn
        vpc_id       = var.vpc_id
      }
    )
  ]
}

