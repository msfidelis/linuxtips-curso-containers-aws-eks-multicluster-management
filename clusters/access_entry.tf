resource "aws_eks_access_entry" "nodes" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.eks_nodes_role.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "fargate" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.fargate.arn
  type          = "FARGATE_LINUX"
}

resource "aws_eks_access_entry" "argocd" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = var.argocd_deployer_role
  type          = "STANDARD"

  kubernetes_groups = [
    "cluster-admin"
  ]
}

resource "aws_eks_access_policy_association" "argocd" {
  cluster_name  = aws_eks_cluster.main.id
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.argocd_deployer_role

  access_scope {
    type       = "cluster"
  }
}