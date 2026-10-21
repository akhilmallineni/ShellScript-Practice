resource "aws_route53_record" "r53" {
  count = length(var.instances)
  zone_id = var.zone_id
  name    = var.instances[count.index] == "frontend" ? "${var.domain_name}" : "${var.instances[count.index]}-${var.environment}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = var.instances[count.index] == "frontend" ? [aws_instance.ec2_inst1[count.index].public_ip] : [aws_instance.ec2_inst1[count.index].private_ip]
}