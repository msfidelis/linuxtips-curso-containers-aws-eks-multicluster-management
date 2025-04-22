resource "aws_lb" "main" {

  name = var.project_name

  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_ssm_parameter.lb_subnets[*].value

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  security_groups = [ 
    aws_security_group.main.id 
 ]

  tags = {
    Name = var.project_name
  }

}


resource "aws_lb_target_group" "argo" {
  name     = var.project_name
  port     = 30080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc.value

  health_check {
    path    = "/"
    matcher = "200-404"
  }
}



resource "aws_lb_listener" "argocd" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.argo.arn
      }
    }
  }
}

resource "aws_security_group" "main" {
  name        = var.project_name    

  vpc_id      = data.aws_ssm_parameter.vpc.value

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name    
  }
}