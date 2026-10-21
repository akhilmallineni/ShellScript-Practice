variable "ami_id" {
    description = "The AMI ID for the EC2 instance"
    type        = string
    default     = "ami-0220d79f3f480ecf5"
}
variable "instance_type" {
    description = "The instance type for the EC2 instance"
    type        = string
    default     = "t3.micro"
}
variable "security_group_name" {
  description = "value"
  type = string
  default = "terraform-allow"
}
variable "port" {
  description = "value"
  type = number
  default = 22

}
variable "cidr" {
    description = "value of the ip"
    type = list(string)
    default = [ "0.0.0.0/0" ]
}
variable "tags" {
  type = map(any)
  default = {
    Name="Roboshop"
  }
}