data "aws_iam_policy_document" "argocd_deployer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ aws_iam_role.argocd.arn ]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argo_deployer" {
  assume_role_policy = data.aws_iam_policy_document.argocd_deployer_assume_role.json
  name               = format("%s-argocd-deployer", var.project_name)
}