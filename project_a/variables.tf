data "aws_availability_zones" "available" {}
variable "aws_access_key" {}
variable "aws_profile" {}
variable "aws_region" {}
variable "aws_secret_key" {}
variable "my_ip" {}
variable "project_name" {}
variable "project_name_short" {}
variable "environment" {}
variable "rds_db_port" {}
variable "rds_db_password" {}
variable "rds_db_allocated_storage" {}
variable "rds_db_engine" {}
variable "rds_db_engine_version" {}
variable "rds_db_instance_class" {}
variable "rds_db_multi_az" {}
variable "rds_db_parameter_group_name" {}
variable "rds_db_storage_type" {}
variable "rds_db_user" {}
variable "rds_db_alias" {}
variable "rds_subnetgroup" {}
variable "rds_security_group" {}
variable "code_pipeline_backend_branch" {}
variable "code_pipeline_frontend_branch" {}
variable "ec2_security_group" {}
variable "github_per_token" {}
variable "subnet_id" {}
