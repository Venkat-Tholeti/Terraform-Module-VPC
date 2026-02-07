output "aws_availability_zones_info" {
  value = data.aws_availability_zones.available
}

output "vpc_id"{
  value = aws_vpc.main.id
}
  
output "public_subnet_id"{
  value = aws_subnet.public[*].id
}