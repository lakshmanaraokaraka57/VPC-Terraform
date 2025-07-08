variable "vpc_cidr" {
  
}
variable "project_name" {
}
variable "environment" {
  
}
variable "common_tags" {
    type=map
    default = {
    
    }
  
}
variable "vpc_tags" {
    default = ["Assignament"]
  
}
variable "igw_tags" {
  default = {

  }
}
// public subnets
variable "cidr_block" { 
  validation {
    condition = length(var.cidr_block)==2
   error_message = "Please provide required subnets cidr blocks"
  }
  
}
// private subnets
variable "private_cidr_block" {
  validation {
    condition = length(var.private_cidr_block)==2
   error_message = "Please provide required subnets cidr blocks"
  }
  
}
variable "public_route_tags" {
  default = {

  }
}
variable "private_route_tags" {
  default = {
    
  }
}
// vpc peering
variable "Is_peering" {
  default = false
  
}