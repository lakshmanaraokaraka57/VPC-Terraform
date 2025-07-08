# output "azs_info" {
#     value=data.aws_availability_zones.available

  
# }
#  output "subnetnets_info" {
#   value = aws_subnet.public
  
# }
output "vpc_id" {
   value = data.aws_vpc.default.id
}

# output "vpc_cidr" {
#   value = data.aws_vpc.default.cidr_block
# }
