
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "${var.project_name}-bastion"
    Project = var.project_name
    Role    = "bastion"
  }
}


resource "aws_launch_template" "frontend_lt" {
  name_prefix   = "${var.project_name}-fe-lt-"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [var.frontend_sg_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-frontend"
      Project = var.project_name
      Role    = "frontend"
    }
  }
}

resource "aws_autoscaling_group" "frontend_asg" {
  name                = "${var.project_name}-fe-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }
}


resource "aws_launch_template" "backend_lt" {
  name_prefix   = "${var.project_name}-be-lt-"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [var.backend_sg_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-backend"
      Project = var.project_name
      Role    = "backend"
    }
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  name                = "${var.project_name}-be-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }
}


resource "aws_instance" "database" {
  count                  = 3
  ami                    = var.ami_id
  instance_type          = "t2.micro" 
  
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.db_sg_id]
  key_name               = var.key_name

  tags = {
    Name    = "${var.project_name}-db-${count.index + 1}"
    Project = var.project_name
    Role    = "database"
  }
}
