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