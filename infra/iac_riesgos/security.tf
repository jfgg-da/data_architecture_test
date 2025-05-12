resource "aws_vpc" "vpc_datos" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name    = "vpc-datos"
    Project = "riesgos"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc_datos.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name    = "subnet-a"
    Project = "riesgos"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc_datos.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name    = "subnet-b"
    Project = "riesgos"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_datos.id
  
  tags = {
    Name    = "igw-datos"
    Project = "riesgos"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_datos.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name    = "rt-public"
    Project = "riesgos"
  }
}

resource "aws_route_table_association" "rt_assoc_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_assoc_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_security_group" "rds_sg" {
  name        = "aurora-access"
  description = "Allow PostgreSQL inbound"
  vpc_id      = aws_vpc.vpc_datos.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Solo acceso desde la VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "aurora-sg"
    Project = "riesgos"
  }
}