terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.24.0"
    }
  }
}

resource "aws_vpc" "sriyansh_main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "sriyansh_main_vpc"
  }
}

resource "aws_internet_gateway" "sriyansh_igw" {
  vpc_id = aws_vpc.sriyansh_main.id
  
  tags = {
    Name = "sriyansh_main_igw"
  }
}

resource "aws_eip" "sriyansh_nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "sriyansh_nat_eip"
  }
}

resource "aws_nat_gateway" "sriyansh_nat" {
  allocation_id = aws_eip.sriyansh_nat_eip.id
  subnet_id     = aws_subnet.sriyansh_public_1.id
  
  tags = {
    Name = "sriyansh_nat_gateway"
  }
  
  depends_on = [aws_internet_gateway.sriyansh_igw]
}

resource "aws_subnet" "sriyansh_public_1" {
  vpc_id                  = aws_vpc.sriyansh_main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "sriyansh_public_subnet_1"
    Type = "Public"
  }
}

resource "aws_subnet" "sriyansh_public_2" {
  vpc_id                  = aws_vpc.sriyansh_main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "sriyansh_public_subnet_2"
    Type = "Public"
  }
}

resource "aws_subnet" "sriyansh_private_1" {
  vpc_id            = aws_vpc.sriyansh_main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name = "sriyansh_private_subnet_1"
    Type = "Private"
  }
}

resource "aws_subnet" "sriyansh_private_2" {
  vpc_id            = aws_vpc.sriyansh_main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1b"
  
  tags = {
    Name = "sriyansh_private_subnet_2"
    Type = "Private"
  }
}

resource "aws_route_table" "sriyansh_public_rt" {
  vpc_id = aws_vpc.sriyansh_main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sriyansh_igw.id
  }
  
  tags = {
    Name = "sriyansh_public_route_table"
  }
}

resource "aws_route_table" "sriyansh_private_rt" {
  vpc_id = aws_vpc.sriyansh_main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sriyansh_nat.id
  }
  
  tags = {
    Name = "sriyansh_private_route_table"
  }
}

resource "aws_route_table_association" "sriyansh_public_1_assoc" {
  subnet_id      = aws_subnet.sriyansh_public_1.id
  route_table_id = aws_route_table.sriyansh_public_rt.id
}

resource "aws_route_table_association" "sriyansh_public_2_assoc" {
  subnet_id      = aws_subnet.sriyansh_public_2.id
  route_table_id = aws_route_table.sriyansh_public_rt.id
}

resource "aws_route_table_association" "sriyansh_private_1_assoc" {
  subnet_id      = aws_subnet.sriyansh_private_1.id
  route_table_id = aws_route_table.sriyansh_private_rt.id
}

resource "aws_route_table_association" "sriyansh_private_2_assoc" {
  subnet_id      = aws_subnet.sriyansh_private_2.id
  route_table_id = aws_route_table.sriyansh_private_rt.id
}
