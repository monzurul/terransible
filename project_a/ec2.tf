resource "aws_instance" "web" {
  ami = "ami-0c5199d385b432989"
  instance_type   = "t2.micro"

  key_name = "projecta-${var.environment}"

  vpc_security_group_ids = [
    "${var.ec2_security_group}",
        ]

  subnet_id = "${var.subnet_id}"

  tags {
    Name = "${var.project_name}-${var.environment}"
  }
}