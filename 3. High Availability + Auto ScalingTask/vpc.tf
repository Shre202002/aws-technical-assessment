resource "aws_vpc" "vishnu_pandey_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vishnu_pandey_vpc"
  }
}

resource "aws_internet_gateway" "vishnu_pandey_igw" {
  vpc_id = aws_vpc.vishnu_pandey_vpc.id

  tags = {
    Name = "vishnu_pandey_igw"
  }
}

resource "aws_subnet" "vishnu_pandey_public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vishnu_pandey_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "vishnu_pandey_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "vishnu_pandey_private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vishnu_pandey_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "vishnu_pandey_private_subnet_${count.index + 1}"
  }
}

resource "aws_route_table" "vishnu_pandey_public_rt" {
  vpc_id = aws_vpc.vishnu_pandey_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vishnu_pandey_igw.id
  }

  tags = {
    Name = "vishnu_pandey_public_rt"
  }
}

resource "aws_route_table_association" "vishnu_pandey_public_rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.vishnu_pandey_public_subnet[count.index].id
  route_table_id = aws_route_table.vishnu_pandey_public_rt.id
}

resource "aws_eip" "vishnu_pandey_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "vishnu_pandey_nat" {
  allocation_id = aws_eip.vishnu_pandey_nat_eip.id
  subnet_id     = aws_subnet.vishnu_pandey_public_subnet[0].id

  tags = {
    Name = "vishnu_pandey_nat"
  }
}

resource "aws_route_table" "vishnu_pandey_private_rt" {
  vpc_id = aws_vpc.vishnu_pandey_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vishnu_pandey_nat.id
  }

  tags = {
    Name = "vishnu_pandey_private_rt"
  }
}

resource "aws_route_table_association" "vishnu_pandey_private_rta" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.vishnu_pandey_private_subnet[count.index].id
  route_table_id = aws_route_table.vishnu_pandey_private_rt.id
}

data "aws_availability_zones" "available" {
  state = "available"
}