data "aws_iam_policy_document" "argocd_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argocd" {
  assume_role_policy = data.aws_iam_policy_document.argocd_assume_role.json
  name               = format("%s-argocd", var.project_name)
}

data "aws_iam_policy_document" "argocd_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    resources = [
      "*"
    ]

  }

}

resource "aws_iam_policy" "argocd_policy" {
  name        = format("%s-argocd-policy", var.project_name)
  path        = "/"
  description = var.project_name

  policy = data.aws_iam_policy_document.argocd_policy.json
}

resource "aws_iam_policy_attachment" "argocd_policy" {
  name = "argocd_policy"

  roles = [aws_iam_role.argocd.name]

  policy_arn = aws_iam_policy.argocd_policy.arn
}

resource "aws_eks_pod_identity_association" "argo_server" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "argocd"
  service_account = "argocd-server"
  role_arn        = aws_iam_role.argocd.arn
}

resource "aws_eks_pod_identity_association" "argo_application_controller" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "argocd"
  service_account = "argocd-application-controller"
  role_arn        = aws_iam_role.argocd.arn
}

resource "aws_eks_pod_identity_association" "argo_applicationset_controller" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "argocd"
  service_account = "argocd-applicationset-controller"
  role_arn        = aws_iam_role.argocd.arn
}