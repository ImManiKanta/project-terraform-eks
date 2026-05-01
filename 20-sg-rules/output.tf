output "my_ip" {
  value = aws_security_group_rule.bastion_internet.cidr_blocks
}