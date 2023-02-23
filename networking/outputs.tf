# -------- networking/output.tf ------------

output "vpc_id" {
    value = aws_vpc.dev_vpc.id
}