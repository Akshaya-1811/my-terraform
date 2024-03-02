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

#WEB-NACL
resource "aws_network_acl" "my-web-nacl" {
  vpc_id = aws_vpc.my-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "web-nacl"
  }
}

#DB-NACL
resource "aws_network_acl" "my-db-nacl" {
  vpc_id = aws_vpc.my-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "db-nacl"
  }
}

#WEB-NACL-ASSC
resource "aws_network_acl_association" "c" {
  network_acl_id = aws_network_acl.my-web-nacl.id
  subnet_id      = aws_subnet.my-web-sn.id
}

#DB-NACL-ASSC
resource "aws_network_acl_association" "d" {
  network_acl_id = aws_network_acl.my-db-nacl.id
  subnet_id      = aws_subnet.my-db-sn.id
}

#WEB-SG
resource "aws_security_group" "my-web-sg" {
  name        = "allow_tls"
  description = "Allow SSH - HTTP outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  tags = {
    Name = "web-sg"
  }
}
  ingress {
    protocol   = "SSH"
    rule_no    = 100
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "HTTP"
    rule_no    = 100
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }


tags = {
    Name = "db-sg"

}
#DB-SG