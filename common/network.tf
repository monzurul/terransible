# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidrs}"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name      = "${var.project_name}"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

# Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

# Route tables
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name      = "${var.project_name}-public-rt"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_default_route_table" "private-rt" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name      = "${var.project_name}-private-rt"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public1-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["public1-sn"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name      = "${var.project_name}-public1-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public2-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["public2-sn"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name      = "${var.project_name}-public2-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private1-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["private1-sn"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name      = "${var.project_name}-private1-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private2-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["private2-sn"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name      = "${var.project_name}-private2-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "rds1-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["rds1-sn"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name      = "${var.project_name}-rds1-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "rds2-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["rds2-sn"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name      = "${var.project_name}-rds2-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "rds3-sn" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidrs["rds3-sn"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name      = "${var.project_name}-rds3-sn"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

# Subnet Associations
resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = "${aws_subnet.public1-sn.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = "${aws_subnet.public2-sn.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = "${aws_subnet.private1-sn.id}"
  route_table_id = "${aws_default_route_table.private-rt.id}"
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = "${aws_subnet.private2-sn.id}"
  route_table_id = "${aws_default_route_table.private-rt.id}"
}

resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "rds-subnetgroup-${var.project_name_short}"
  subnet_ids = ["${aws_subnet.rds1-sn.id}", "${aws_subnet.rds2-sn.id}", "${aws_subnet.rds3-sn.id}"]

  tags {
    Name      = "${var.project_name}-rds-sng"
    Group     = "${var.project_name}"
    ManagedBy = "Terraform"
  }
}

# Security groups
resource "aws_security_group" "site-sg" {
  name        = "site-sg"
  description = "Used for access to the EC2 instance"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidrs}"]
  }
}

resource "aws_security_group" "public-sg" {
  name        = "public-sg"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Security Group
resource "aws_security_group" "private-sg" {
  name        = "private-sg"
  description = "Used for private instances"
  vpc_id      = "${aws_vpc.vpc.id}"

  # Access from other security groups

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidrs}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Used for DB instances"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SQL access from public/private security group
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidrs}"]
  }
}
