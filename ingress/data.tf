data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc
}

data "aws_ssm_parameter" "subnets" {
  count = length(var.ssm_subnets)
  name  = var.ssm_subnets[count.index]
}