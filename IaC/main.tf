terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
     docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

provider "docker" {
}

# vpc 생성
resource "aws_vpc" "nahye_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "nahye_vpc"
  }
}

# vpc 내 서브넷 4개 생성 (퍼블릭 2개, 프라이빗 2개)
# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.nahye_vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.nahye_vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.nahye_vpc.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.nahye_vpc.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_subnet_2"
  }
}

# 서브넷 그룹 설정
resource "aws_db_subnet_group" "subnet_group" {
  name = "subnet_group"
  
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  
}

# IGW 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nahye_vpc.id

  tags = {
    Name = "igw"
  }
}

# 라우팅 테이블 생성
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nahye_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# 라우팅 테이블 연결
resource "aws_route_table_association" "pubassociation1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "pubassociation2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# NGW 생성
resource "aws_eip" "eip" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "ngw"
  }
}

# 라우팅 테이블 생성
resource "aws_route_table" "prvroutetable_1" {
  vpc_id = aws_vpc.nahye_vpc.id

  tags = {
    Name = "prvroutetable_1"
  }
}

resource "aws_route_table" "prvroutetable_2" {
  vpc_id = aws_vpc.nahye_vpc.id

  tags = {
    Name = "prvroutetable_2"
  }
}

# 라우팅 테이블 연결
resource "aws_route_table_association" "prvassociation1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.prvroutetable_1.id
}

resource "aws_route_table_association" "prvassociation2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.prvroutetable_2.id
}

resource "aws_route" "prvroute_1" {
  route_table_id         = aws_route_table.prvroutetable_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route" "prvroute-2-by-tf" {
  route_table_id         = aws_route_table.prvroutetable_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}