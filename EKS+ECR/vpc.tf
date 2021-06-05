#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" : "terraform-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}" : "shared"
  }
}

resource "aws_subnet" "eks-subnet" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks-vpc.id

  tags = {
    "Name" : "terraform-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}" : "shared"
  }
}

resource "aws_internet_gateway" "eks-ig" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "terraform-eks-ig"
  }
}

resource "aws_route_table" "eks-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-ig.id
  }
}

resource "aws_route_table_association" "eks-rt-asso" {
  count = 2

  subnet_id      = aws_subnet.eks-subnet.*.id[count.index]
  route_table_id = aws_route_table.eks-rt.id
}
