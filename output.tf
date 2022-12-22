output "vpc_id" {
  value = aws_vpc.this.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.this : v.tags.Name => v.id }
}

output "aws_route_table_association" {
  value = [for k, v in aws_subnet.this : v.id]
}

output "sg_alb_id" {
  value = aws_security_group.alb.id

}

output "alb_id" {
  value = aws_alb.this.id
}
