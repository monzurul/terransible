resource "aws_instance" "web" {
  ami = "ami-0b0a60c0a2bd40612"
  instance_type   = "t2.micro"

  key_name = "projectA-${var.environment}"

  vpc_security_group_ids = [
    "${var.ec2_security_group_id}",
        ]

  subnet_id = "${var.subnet_id}"

  tags {
    Name = "${var.project_name}-${var.environment}"
  }
}