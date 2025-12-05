resource "aws_vpc" "sriyansh_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sriyansh_vpc"
  }
}

resource "aws_internet_gateway" "sriyansh_igw" {
  vpc_id = aws_vpc.sriyansh_vpc.id

  tags = {
    Name = "sriyansh_igw"
  }
}

resource "aws_subnet" "sriyansh_public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.sriyansh_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "sriyansh_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "sriyansh_private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.sriyansh_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "sriyansh_private_subnet_${count.index + 1}"
  }
}

resource "aws_route_table" "sriyansh_public_rt" {
  vpc_id = aws_vpc.sriyansh_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sriyansh_igw.id
  }

  tags = {
    Name = "sriyansh_public_rt"
  }
}

resource "aws_route_table_association" "sriyansh_public_rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.sriyansh_public_subnet[count.index].id
  route_table_id = aws_route_table.sriyansh_public_rt.id
}

resource "aws_eip" "sriyansh_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "sriyansh_nat" {
  allocation_id = aws_eip.sriyansh_nat_eip.id
  subnet_id     = aws_subnet.sriyansh_public_subnet[0].id

  tags = {
    Name = "sriyansh_nat"
  }
}

resource "aws_route_table" "sriyansh_private_rt" {
  vpc_id = aws_vpc.sriyansh_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sriyansh_nat.id
  }

  tags = {
    Name = "sriyansh_private_rt"
  }
}

resource "aws_route_table_association" "sriyansh_private_rta" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.sriyansh_private_subnet[count.index].id
  route_table_id = aws_route_table.sriyansh_private_rt.id
}

data "aws_availability_zones" "available" {
  state = "available"
}
