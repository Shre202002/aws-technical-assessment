output "vishnu_pandey_alb_dns" {
  value = aws_lb.vishnu_pandey_alb.dns_name
}

output "vishnu_pandey_vpc_id" {
  value = aws_vpc.vishnu_pandey_vpc.id
}

output "vishnu_pandey_public_subnets" {
  value = aws_subnet.vishnu_pandey_public_subnet[*].id
}

output "vishnu_pandey_private_subnets" {
  value = aws_subnet.vishnu_pandey_private_subnet[*].id
}