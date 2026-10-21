resource "aws_instance" "ec2_inst1" {
    ami            = var.ami_id #"ami-0220d79f3f480ecf5"
    instance_type  = var.instance_type
    vpc_security_group_ids = [aws_security_group.terraform_allow.id] #"t3.micro"
    tags = var.tags
}

resource "aws_security_group" "terraform_allow" {
    name        = var.security_group_name
    description = "Allow inbound traffic"

      # outbound traffic
  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "-1" # all traffic
    cidr_blocks = var.cidr
  }
    tags = var.tags
}