resource "aws_subnet" "private_subnet_one" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = "${var.ips_subnets[2]}/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]

  tags = {
    Name = "${var.project_name}-private-subnet-one"
  }
}

resource "aws_subnet" "private_subnet_two" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = "${var.ips_subnets[3]}/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]

  tags = {
    Name = "${var.project_name}-private-subnet-two"
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.gw]
  domain     = "vpc"

  tags = {
    Name = "${var.project_name}-eip-nat"
  }
}

resource "aws_nat_gateway" "nat_gatewway" {
  subnet_id     = aws_subnet.public_subnet_one.id
  allocation_id = aws_eip.eip.id  

  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gatewway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

resource "aws_route_table_association" "priv_one" {
  subnet_id      = aws_subnet.private_subnet_one.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "priv_two" {
  subnet_id      = aws_subnet.private_subnet_two.id
  route_table_id = aws_route_table.route_table_private.id
}