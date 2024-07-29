terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "game_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "game_igw" {
  vpc_id = aws_vpc.game_vpc.id

  tags = {
    Name = "game-igw"
  }
}

# Public Subnet 1
resource "aws_subnet" "game_pub01" {
  vpc_id                  = aws_vpc.game_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "game-pub01"
  }
}

# Public Subnet 2
resource "aws_subnet" "game_pub02" {
  vpc_id                  = aws_vpc.game_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "game-pub02"
  }
}

# Private Subnet 1
resource "aws_subnet" "game_priv01" {
  vpc_id            = aws_vpc.game_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "game-priv01"
  }
}

# Private Subnet 2
resource "aws_subnet" "game_priv02" {
  vpc_id            = aws_vpc.game_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "game-priv02"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "game_pub_rt" {
  vpc_id = aws_vpc.game_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.game_igw.id
  }

  tags = {
    Name = "game-pub-rt"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "game_pub_rt_association_pub01" {
  subnet_id      = aws_subnet.game_pub01.id
  route_table_id = aws_route_table.game_pub_rt.id
}

resource "aws_route_table_association" "game_pub_rt_association_pub02" {
  subnet_id      = aws_subnet.game_pub02.id
  route_table_id = aws_route_table.game_pub_rt.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "game_ngw_eip1" {
  vpc = true
}

resource "aws_eip" "game_ngw_eip2" {
  vpc = true
}

resource "aws_eip" "game_ngw_eip3" {
  vpc = true
}

resource "aws_eip" "game_ngw_eip4" {
  vpc = true
}

# NAT Gateway 1
resource "aws_nat_gateway" "game_ngw1" {
  allocation_id = aws_eip.game_ngw_eip1.id
  subnet_id     = aws_subnet.game_pub01.id

  tags = {
    Name = "game-ngw1"
  }
}

# NAT Gateway 2
resource "aws_nat_gateway" "game_ngw2" {
  allocation_id = aws_eip.game_ngw_eip2.id
  subnet_id     = aws_subnet.game_pub02.id

  tags = {
    Name = "game-ngw2"
  }
}

# NAT Gateway 3
resource "aws_nat_gateway" "game_ngw3" {
  allocation_id = aws_eip.game_ngw_eip3.id
  subnet_id     = aws_subnet.game_pub01.id

  tags = {
    Name = "game-ngw3"
  }
}

# NAT Gateway 4
resource "aws_nat_gateway" "game_ngw4" {
  allocation_id = aws_eip.game_ngw_eip4.id
  subnet_id     = aws_subnet.game_pub02.id

  tags = {
    Name = "game-ngw4"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "game_priv_rt_1" {
  vpc_id = aws_vpc.game_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.game_ngw1.id
  }

  tags = {
    Name = "game-priv-rt-1"
  }
}

resource "aws_route_table" "game_priv_rt_2" {
  vpc_id = aws_vpc.game_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.game_ngw2.id
  }

  tags = {
    Name = "game-priv-rt-2"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "game_priv_rt_association_priv01" {
  subnet_id      = aws_subnet.game_priv01.id
  route_table_id = aws_route_table.game_priv_rt_1.id
}

resource "aws_route_table_association" "game_priv_rt_association_priv02" {
  subnet_id      = aws_subnet.game_priv02.id
  route_table_id = aws_route_table.game_priv_rt_2.id
}

# Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg" 
  vpc_id = aws_vpc.game_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.game_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Target Group
resource "aws_lb_target_group" "supermario_tg" {
  name     = "supermario-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.game_vpc.id
  target_type = "ip"
  
  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "supermario-tg"
  }
}

# Application Load Balancer
resource "aws_lb" "supermario_alb" {
  name               = "supermario-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.game_pub01.id, aws_subnet.game_pub02.id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "supermario-alb"
  }
}

# Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.supermario_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.supermario_tg.arn
  }
}
# ECS Cluster
resource "aws_ecs_cluster" "supermario_cluster" {
  name = "supermario-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
