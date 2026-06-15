output "bastion_ip" {
  value = module.compute.bastion_public_ip
}

output "database_ips" {
  value = module.compute.database_private_ips
}

output "app_url" {
  value = "http://${module.load_balancer.external_alb_dns}"
}

output "backend_internal_url" {
  value = "http://${module.load_balancer.internal_alb_dns}"
}
