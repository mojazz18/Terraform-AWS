terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc-main" {
  cidr_block = "10.128.0.0/16"

}
# Create the Subnets
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.128.0.0/24"

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.128.1.0/24"

  tags = {
    Name = "PrivateSubnet"
  }
}
# Create the Internet Gateway
resource "aws_internet_gateway" "InternetGW" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "InternetGW"
  }
}
# Create the Route Tables
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGW.id
  }

  tags = {
    Name = "PublicRT"
  }
}
# Create the Route table associations to the Subnets
resource "aws_route_table_association" "PublicRT" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}
