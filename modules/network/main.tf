locals {
  public_cidrs = [
    for subnet_number in range (0,3):
    cidrsubnet(var.vpc_cidr, 8 , subnet_number)
  ]

  webapp_cidrs = [
    for subnet_number in range (3,6):
    cidrsubnet(var.vpc_cidr, 8 , subnet_number)
  ]

  database_cidrs = [
    for subnet_number in range (6,9):
    cidrsubnet(var.vpc_cidr, 8 , subnet_number)
  ]
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-2"
  }
}

resource "aws_subnet" "public-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_cidrs[2]
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-3"
  }
}

resource "aws_subnet" "web-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.webapp_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-web-subnet-1"
  }

}

resource "aws_subnet" "web-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.webapp_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-web-subnet-2"
  }
}

resource "aws_subnet" "web-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.webapp_cidrs[2]
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-web-subnet-3"
  }
}

resource "aws_subnet" "database-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.database_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-database-subnet-1"
  }
}

resource "aws_subnet" "database-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.database_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-database-subnet-2"
  }
}

resource "aws_subnet" "database-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.database_cidrs[2]
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = false

 tags = {
    Name = "${var.environment}-database-subnet-3"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
     Name = "${var.environment}-public-rt"
  }

}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "web-aza" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-a.id
  }

  tags = {
     Name = "${var.environment}-web-aza-rt"
  }

}


resource "aws_route_table_association" "web_aza" {
  subnet_id      = aws_subnet.web-1.id
  route_table_id = aws_route_table.web-aza.id
}

resource "aws_route_table" "web-azb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-b.id
  }

  tags = {
     Name = "${var.environment}-web-azb-rt"
  }

}

resource "aws_route_table_association" "web_azb" {
  subnet_id      = aws_subnet.web-2.id
  route_table_id = aws_route_table.web-azb.id
}

resource "aws_route_table" "web-azc" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-c.id
  }

   tags = {
     Name = "${var.environment}-web-azc-rt"
  }

}

resource "aws_route_table_association" "web_azc" {
  subnet_id      = aws_subnet.web-3.id
  route_table_id = aws_route_table.web-azc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_nat_gateway" "nat-az-a" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.nat_a.id

  depends_on = [
    aws_subnet.public-1
  ]

  tags = {
    Name = "${var.environment}-nat-aza"
  }
}

resource "aws_nat_gateway" "nat-az-b" {
  subnet_id     = aws_subnet.public-2.id
  allocation_id = aws_eip.nat_b.id

  depends_on = [
    aws_subnet.public-2
  ]
  tags = {
    Name = "${var.environment}-nat-azb"
  }
}

resource "aws_nat_gateway" "nat-az-c" {
  subnet_id     = aws_subnet.public-3.id
  allocation_id = aws_eip.nat_c.id

  depends_on = [
    aws_subnet.public-3
  ]

  tags = {
    Name = "${var.environment}-nat-azc"
  }
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-eip-nat-aza"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-eip-nat-azb"
  }
}

resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-eip-nat-azc"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

   tags = {
     Name = "${var.environment}-database-rt"
  }
}

resource "aws_route_table_association" "database_aza" {
  subnet_id      = aws_subnet.database-1.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_azb" {
  subnet_id      = aws_subnet.database-2.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_azc" {
  subnet_id      = aws_subnet.database-3.id
  route_table_id = aws_route_table.database.id
}