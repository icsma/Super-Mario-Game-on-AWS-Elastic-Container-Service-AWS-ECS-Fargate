output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.game_vpc.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.game_igw.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.game_pub01.id, aws_subnet.game_pub02.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.game_priv01.id, aws_subnet.game_priv02.id]
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways"
  value       = [
    aws_nat_gateway.game_ngw1.id,
    aws_nat_gateway.game_ngw2.id,
    aws_nat_gateway.game_ngw3.id,
    aws_nat_gateway.game_ngw4.id
  ]
}

output "ecs_sg_id" {
  description = "The ID of the ECS Security Group"
  value       = aws_security_group.ecs_sg.id
}
