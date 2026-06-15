output "bastion_sg_id" {
  value       = aws_security_group.bastion_sg.id
  description = "Security Group ID for the Bastion Host"
}

output "ext_alb_sg_id" {
  value       = aws_security_group.ext_alb_sg.id
  description = "Security Group ID for the External Application Load Balancer"
}

output "frontend_sg_id" {
  value       = aws_security_group.frontend_sg.id
  description = "Security Group ID for the Frontend EC2 instances"
}

output "int_alb_sg_id" {
  value       = aws_security_group.int_alb_sg.id
  description = "Security Group ID for the Internal Application Load Balancer"
}

output "backend_sg_id" {
  value       = aws_security_group.backend_sg.id
  description = "Security Group ID for the Backend EC2 instances"
}

output "db_sg_id" {
  value       = aws_security_group.db_sg.id
  description = "Security Group ID for the Database EC2 instances"
}
