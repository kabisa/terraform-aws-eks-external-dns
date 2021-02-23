data "template_file" "external-dns" {
  template = file("${path.module}/yamls/external-dns-values.yaml")
  vars     = {
    region        = var.region
    aws_role_arn  = aws_iam_role.external-dns-iam-role.arn
    vpc_id        = var.vpc_id
  }
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "4.8.3"
  # appVersion: 0.7.6

  values = [
    data.template_file.external-dns.rendered
  ]
}

