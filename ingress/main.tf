resource "aws_lb" "main" {

  name = var.project_name

  internal = false

  load_balancer_type = "application"

  subnets = data.aws_ssm_parameter.subnets[*].value

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false


  security_groups = [
    aws_security_group.main.id
  ]

  tags = {
    Name = var.project_name
  }

}