resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_ip}/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
    Environment = "clustereks"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-ig-vpc"
  }
}