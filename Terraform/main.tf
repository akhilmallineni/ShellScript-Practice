resource "aws_instance" "ec2_inst1" {
    ami           = "ami-0220d79f3f480ecf5"
    instance_type = "t3.micro"
}