resource "aws_vpc" "main" {   // VPC creation
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags=merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name=local.resource_name
    }
  )
}
// Internet Gateway Creation
resource "aws_internet_gateway" "gateways" {
  vpc_id = aws_vpc.main.id
  tags=merge(
    var.common_tags,
    var.igw_tags,
    {
      Name=local.resource_name
    }
  )
  
}
// creating public subnets
resource "aws_subnet" "public" {
  count=length(var.cidr_block)
  vpc_id = aws_vpc.main.id
  cidr_block = var.cidr_block[count.index]
  availability_zone = local.azs_names[count.index]
  map_public_ip_on_launch = true
  tags=merge(
    var.common_tags,
    {
      Name="${local.resource_name}-public-${local.azs_names[count.index]}"
    }
  )
   
  }
  // creating private subnets
  resource "aws_subnet" "private" {
  count=length(var.private_cidr_block)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = local.azs_names[count.index]
  map_public_ip_on_launch = true
  tags=merge(
    var.common_tags,
    {
      Name="${local.resource_name}-private-${local.azs_names[count.index]}"
    }
  )
   
  }
  // NAT Creation
  resource "aws_eip" "nat" {
    domain = "vpc"
  }
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT Gateway"
  }
}
// Route Table creation
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags=merge(
    var.common_tags,
    var.public_route_tags,
    {
      Name="${local.resource_name}-public"
    }
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
 tags=merge(
    var.common_tags,
    var.private_route_tags,
    {
      Name="${local.resource_name}-private"
    }
  )
}
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateways.id
}
resource "aws_route" "private" {
  route_table_id            =aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
 nat_gateway_id =  aws_nat_gateway.example.id
}
// subnet assiciation to route table
resource "aws_route_table_association" "public" {
  count=length(var.cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count=length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
