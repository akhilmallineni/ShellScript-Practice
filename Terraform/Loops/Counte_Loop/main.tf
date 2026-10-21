resource "aws_instance" "ec2_inst1" {
    #count = 2
    count = length(var.instances)
    ami            = var.ami_id #"ami-0220d79f3f480ecf5"
    instance_type  =  "t3.micro"
    vpc_security_group_ids = [aws_security_group.terraform_allow[count.index].id] #"t3.micro"
    tags = var.tags

}

resource "aws_security_group" "terraform_allow" {
    #count = 2
    count = length(var.instances)
    name        = "${var.environment}-${var.security_group_name}-${count.index}"
    description = "Allow inbound traffic"

      # outbound traffic
  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "-1" # all traffic
    cidr_blocks = var.cidr
  }
    tags = var.tags
    lifecycle {
      create_before_destroy = true
    }
}
