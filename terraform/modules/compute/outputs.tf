output "bastion_public_ip" {
  description = "Public IP of the Bastion Host for SSH access"
  value       = aws_instance.bastion.public_ip
}

output "database_private_ips" {
  description = "Private IPs of the MongoDB instances for Replica Set configuration"
  value       = aws_instance.database[*].private_ip 
}

output "frontend_asg_name" {
  description = "Name of the Frontend Auto Scaling Group"
  value       = aws_autoscaling_group.frontend_asg.name
}

output "backend_asg_name" {
  description = "Name of the Backend Auto Scaling Group"
  value       = aws_autoscaling_group.backend_asg.name
}
