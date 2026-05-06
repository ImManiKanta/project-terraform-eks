resource "aws_lb" "ingress" {
  name               = "ingress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.ingress_alb_sg_id]
  subnets            = local.public_subnet_ids

  enable_deletion_protection = false


  tags = {
    Terraform = "true"
    Name = "ingress-alb"
  }
}

resource "aws_lb_listener" "ingress" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.frontend_alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "ingress" {
  name        = "ingress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
  deregistration_delay = 60

    health_check {
        interval = 10
        path = "/"
        port = 80
        protocol = "HTTP"
        timeout = 2
        healthy_threshold = 2
        unhealthy_threshold = 3
        matcher = "200-299"

    }
}

resource "aws_lb_listener_rule" "ingress" {
  listener_arn = aws_lb_listener.ingress.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }

  condition {
    host_header {
      values = ["${var.project}-${var.environment}.${var.domain_name}"]
    }
  }
}


resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.project}-${var.environment}.${var.domain_name}"
  type    = "A"
  
  # load balancer details
  alias {
    name                   = aws_lb.ingress.dns_name
    zone_id                = aws_lb.ingress.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}
