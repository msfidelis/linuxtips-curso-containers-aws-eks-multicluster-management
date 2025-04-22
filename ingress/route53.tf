
resource "aws_route53_record" "dns" {
  zone_id = var.route53_hosted_zone
  name    = var.dns_name

  type = "A"

  alias {
    evaluate_target_health = true
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
  }

}