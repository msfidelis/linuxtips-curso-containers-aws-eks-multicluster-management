data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc
}

data "aws_ssm_parameter" "subnets" {
  count = length(var.ssm_subnets)
  name  = var.ssm_subnets[count.index]
}

data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.main.id
}

data "aws_ssm_parameter" "karpenter_ami" {
  count = length(var.karpenter_capacity)
  name  = var.karpenter_capacity[count.index].ami_ssm
}

data "aws_ssm_parameter" "tg" {
  name = var.istio_ssm_target_group
}