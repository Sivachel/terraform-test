resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "public-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "web-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "web-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "web-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "database-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "database-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "database-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = false

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
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

}

resource "aws_route_table_association" "web_azc" {
  subnet_id      = aws_subnet.web-3.id
  route_table_id = aws_route_table.web-azc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_nat_gateway" "nat-az-a" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.nat_a.id

  depends_on = [
    aws_subnet.public-1
  ]
}

resource "aws_nat_gateway" "nat-az-b" {
  subnet_id     = aws_subnet.public-2.id
  allocation_id = aws_eip.nat_b.id

  depends_on = [
    aws_subnet.public-2
  ]
}

resource "aws_nat_gateway" "nat-az-c" {
  subnet_id     = aws_subnet.public-3.id
  allocation_id = aws_eip.nat_c.id

  depends_on = [
    aws_subnet.public-3
  ]
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

}

resource "aws_eip" "nat_b" {
  domain = "vpc"

}

resource "aws_eip" "nat_c" {
  domain = "vpc"

}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

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