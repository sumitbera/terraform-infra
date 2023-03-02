# -------- networking/main.tf --------

data "aws_availability_zones" "available" {
  
}

resource "random_integer" "random" {
    min = 1
    max = 100
}

resource "aws_vpc" "dev_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "dev-vpc-${random_integer.random.id}"
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_subnet" "dev_public_subnet" {
    count = var.public_sn_count
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]
    
    tags ={
        Name = "dev-public-${count.index + 1}"
    }
 
}

resource "aws_route_table_association" "public-rt-association" {
  count = var.public_sn_count
  subnet_id = aws_subnet.dev_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.dev-public-rt.id
}

resource "aws_subnet" "dev_private_subnet" {
  count = var.private_sn_count
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "dev-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "dev_internet_gateway" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    "Name" = "dev_igw"
  }
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    "Name" = "public-rt"
  }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.dev-public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_internet_gateway.id
}

resource "aws_default_route_table" "dev-private-rt" {
  default_route_table_id = aws_vpc.dev_vpc.default_route_table_id

  tags = {
    "Name" = "private-rt"
  }
}

resource "aws_security_group" "dev-sg" {
  name = "dev-public-sg"
  description = "vpc public access"
  vpc_id = aws_vpc.dev_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}