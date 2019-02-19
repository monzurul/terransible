resource "aws_db_instance" "rds" {
  allocated_storage    = "${var.rds_db_allocated_storage}"
  storage_type         = "${var.rds_db_storage_type}"
  engine               = "${var.rds_db_engine}"
  engine_version       = "${var.rds_db_engine_version}"
  identifier           = "${var.project_name}-${var.environment}"
  instance_class       = "${var.rds_db_instance_class}"
  name                 = "${var.project_name}${var.environment}"
  username             = "${var.project_name}${var.environment}"
  password             = "${var.rds_db_password}"
  multi_az             = "${var.rds_db_multi_az}"
  db_subnet_group_name = "${var.rds_subnetgroup}"

  vpc_security_group_ids  = ["${var.rds_security_group}"]

  backup_retention_period = 3
  publicly_accessible     = true
  skip_final_snapshot     = true
  port                    = "${var.rds_db_port}"
  copy_tags_to_snapshot   = true

  tags {
    Name      = "${var.project_name}-${var.environment}"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}
