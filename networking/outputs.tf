# -------- networking/output.tf ------------

output "vpc_id" {
    value = aws_vpc.dev_vpc.id
}

output "public_sg" {
  value = aws_security_group.dev-sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.dev_public_subnet.*.id
}