#VPC
resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "akshaya"
  }
}

#WEB-SUBNET
resource "aws_subnet" "my-web-sn" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch="true"

  tags = {
    Name = "web-sn"
  }
}

#DATABSE-SUBNET
resource "aws_subnet" "my-db-sn" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "db-sn"
  }
}

#INTERNET-GATEWAY
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

#WEB-RT
resource "aws_route_table" "my-web-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }


  tags = {
    Name = "web-rt"
  }
}

#DB-RT
resource "aws_route_table" "my-db-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "db-rt"
  }
}

#WEB-RT-ASSC
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-web-sn.id
  route_table_id = aws_route_table.my-web-rt.id
}

#DB-RT-ASSC
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.my-db-sn.id
  route_table_id = aws_route_table.my-db-rt.id
}