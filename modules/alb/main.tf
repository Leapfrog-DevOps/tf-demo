## Create Application Load Balancer
resource "aws_lb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.security_group_alb.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = var.enable_deletion_protection
  tags = merge({
    Name = "${var.alb_name}-${var.stage}"
  })
}

## Create Target Group
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.aws_acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.id
  }
}

## Create HTTP Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.tg.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }
}
resource "aws_lb_target_group" "tg" {
  name        = var.lb_target_group_name
  port        = var.target_group_port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = var.protocol
    matcher             = "200"
    timeout             = "5"
    unhealthy_threshold = "2"
  }
  depends_on = [aws_lb.alb]
}

## Create Listener Rule
resource "aws_alb_listener_rule" "main" {
  listener_arn = aws_lb_listener.alb_listener_https.arn
  depends_on   = [aws_lb_listener.alb_listener_https]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  condition {
    host_header {
      values = [var.domain_name]
    }
  }
}


## 
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_id
  port             = 80
}
