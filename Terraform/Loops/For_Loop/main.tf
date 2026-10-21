resource "aws_instance" "ec2_inst1" {
    for_each = var.instances
    ami            = var.ami_id #"ami-0220d79f3f480ecf5"
    instance_type  =  each.value.instance_type
    vpc_security_group_ids = [aws_security_group.terraform_allow[each.key].id] #"t3.micro"
    tags = merge(var.tags, {"Project" = "Akhil"})

}

resource "aws_security_group" "terraform_allow" {
    for_each = var.instances
    name        = "${var.environment}-${var.security_group_name}-${each.key}"
    description = "Allow inbound traffic"

      # outbound traffic
  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "-1" # all traffic
    cidr_blocks = var.cidr
  }
    tags = merge(var.tags, {"Project" = "Akhil"})
    lifecycle {
      create_before_destroy = true
    }
}
