resource "aws_lb" "external_alb" {
  name               = "${var.project_name}-ext-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ext_alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = { Name = "${var.project_name}-ext-alb" }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.project_name}-fe-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.external_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb" "internal_alb" {
  name               = "${var.project_name}-int-alb"
  internal           = true 
  load_balancer_type = "application"
  security_groups    = [var.int_alb_sg_id]
  subnets            = var.private_subnet_ids

  tags = { Name = "${var.project_name}-int-alb" }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "${var.project_name}-be-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health" 
    interval            = 30
    port                = "3000"
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
