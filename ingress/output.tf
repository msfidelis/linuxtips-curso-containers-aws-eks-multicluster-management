output "ssm_target_group_01" {
  value = aws_ssm_parameter.cluster_01.id
}

output "ssm_target_group_02" {
  value = aws_ssm_parameter.cluster_02.id
}