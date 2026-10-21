resource "aws_route53_record" "r53" {
  for_each = var.instances
  zone_id = var.zone_id
  name    = each.key == "frontend" ? var.domain_name : "${each.key}-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = each.key == "frontend" ? [aws_instance.ec2_inst1[each.key].public_ip] : [aws_instance.ec2_inst1[each.key].private_ip]
}