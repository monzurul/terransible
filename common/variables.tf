data "aws_availability_zones" "available" {}
variable "aws_access_key" {}
variable "aws_profile" {}
variable "aws_region" {}
variable "aws_secret_key" {}
variable "my_ip" {}
variable "project_name" {}
variable "project_name_short" {}

variable "subnet_cidrs" {
  type = "map"
}

variable "vpc_cidrs" {}
