resource "aws_subnet" "public_subnet_one" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = "${var.ips_subnets[0]}/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]

  tags = {
    Name = "${var.project_name}-public-subnet-one"
  }
}

resource "aws_subnet" "public_subnet_two" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = "${var.ips_subnets[1]}/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]

  tags = {
    Name = "${var.project_name}-public-subnet-two"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

resource "aws_route_table_association" "one" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "two" {
  subnet_id      = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.route_table_public.id
}