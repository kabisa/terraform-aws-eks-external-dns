data "aws_iam_policy_document" "policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/*"]
    actions   = ["route53:ChangeResourceRecordSets"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
  }
}

resource "aws_iam_policy" "external-dns-iam-policy" {
  name   = "EksExternalDnsIAMPolicy"
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role" "external-dns-iam-role" {
  name = "EksExternalDnsIAMRole"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${var.oidc_host_path}:aud" = "sts.amazonaws.com"
            }
          }
          Effect = "Allow",
          Principal = {
            Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_host_path}"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "external-dns-iam-role-policy-attachment" {
  role       = aws_iam_role.external-dns-iam-role.name
  policy_arn = aws_iam_policy.external-dns-iam-policy.arn
}
