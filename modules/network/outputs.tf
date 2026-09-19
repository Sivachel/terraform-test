# output "lb_dns_name" {
#   description = "The DNS name of the load balancer"
#   value       = aws_lb.elb.dns_name
# }

output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet_1" {
  value = aws_subnet.public-1.id
}

output "public_subnet_2" {
    value = aws_subnet.public-2.id
}

output "public_subnet_3" {
  value = aws_subnet.public-3.id
}

output "web_subnet_1" {
  value = aws_subnet.web-1.id
}

output "web_subnet_2" {
  value = aws_subnet.web-2.id
}

output "web_subnet_3" {
  value = aws_subnet.web-3.id
}

output "database_subnet_1" {
  value = aws_subnet.database-1.id
}

output "database_subnet_2" {
  value = aws_subnet.database-2.id
}

output "database_subnet_3" {
  value = aws_subnet.database-3.id
}