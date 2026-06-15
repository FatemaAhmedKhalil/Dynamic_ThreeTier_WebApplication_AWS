module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
  
  azs           = ["us-east-1a", "us-east-1b"]
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.networking.vpc_id
  project_name = var.project_name
}

module "compute" {
  source             = "./modules/compute"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  key_name           = var.key_name
  ami_id             = var.ami_id
  
  bastion_sg_id      = module.security.bastion_sg_id
  frontend_sg_id     = module.security.frontend_sg_id
  backend_sg_id      = module.security.backend_sg_id
  db_sg_id           = module.security.db_sg_id
}

module "load_balancer" {
  source             = "./modules/load_balancer"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  ext_alb_sg_id      = module.security.ext_alb_sg_id
  int_alb_sg_id      = module.security.int_alb_sg_id
}

resource "aws_autoscaling_attachment" "asg_attachment_fe" {
  autoscaling_group_name = module.compute.frontend_asg_name
  lb_target_group_arn    = module.load_balancer.frontend_tg_arn
}

resource "aws_autoscaling_attachment" "asg_attachment_be" {
  autoscaling_group_name = module.compute.backend_asg_name
  lb_target_group_arn    = module.load_balancer.backend_tg_arn
}
