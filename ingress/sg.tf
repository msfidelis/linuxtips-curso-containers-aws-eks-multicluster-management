resource "aws_security_group" "main" {
  name   = var.project_name
  vpc_id = data.aws_ssm_parameter.vpc.value


  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = var.project_name
  }
}