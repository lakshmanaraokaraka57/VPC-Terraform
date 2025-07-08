resource "aws_vpc_peering_connection" "Requestor" {
    count=var.Is_peering ? 1 : 0
  vpc_id      = aws_vpc.main.id // requestor vpc cidr
  peer_vpc_id = local.default_vpc_id // accceptor vpc cidr
  auto_accept = true
  tags={
    Name="Public-vpc-peering"
  }
}
// subnets adding in route
resource "aws_route" "public_peering" {
  count=var.Is_peering ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.Requestor[count.index].id
}