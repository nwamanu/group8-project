#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

# Create a custom vpc

resource "aws_vpc" "edgecontent" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "edgecontent_vpc"
  }

}

#configure igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.edgecontent.id

  tags = {
    Name = "edgecontentigw"
  }
}

#configure private subnet in two Azs 
resource "aws_subnet" "private1-edgecontent" {
  vpc_id            = aws_vpc.edgecontent.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "edgecontent-private-subnet1"
  }
}

resource "aws_subnet" "private2-edgecontent" {
  vpc_id            = aws_vpc.edgecontent.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "edgecontent-private-subnet2"
  }
}

#Publicsubnet
resource "aws_subnet" "public-edgecontent" {
  vpc_id                  = aws_vpc.edgecontent.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "edgecontent-public-subnet"
  }
}

#Publicsubnet
resource "aws_subnet" "public-edgecontent2" {
  vpc_id                  = aws_vpc.edgecontent.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "edgecontent-public-subnet3"
  }
}

#route table associated with igw
resource "aws_route_table" "edgecontent" {
  vpc_id = aws_vpc.edgecontent.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "edgecontentrt"
  }
}

#public rt assn
resource "aws_route_table_association" "edgecontert-assn" {
  subnet_id      = aws_subnet.public-edgecontent.id
  route_table_id = aws_route_table.edgecontent.id
}

#aws_default
resource "aws_default_route_table" "edgedefault-rt" {
  default_route_table_id = aws_vpc.edgecontent.default_route_table_id

  tags = {
    Name = "edge-default-rt"
  }
}
