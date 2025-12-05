output "sriyansh_alb_dns" {
  value = aws_lb.sriyansh_alb.dns_name
}

output "sriyansh_vpc_id" {
  value = aws_vpc.sriyansh_vpc.id
}

output "sriyansh_public_subnets" {
  value = aws_subnet.sriyansh_public_subnet[*].id
}

output "sriyansh_private_subnets" {
  value = aws_subnet.sriyansh_private_subnet[*].id
}
