resource "aws_lb" "main" {
  name               = "${var.project_name}-application-elb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id, aws_security_group.lb_main.id]
  subnets            = [aws_subnet.lb_public_1a.id, aws_subnet.lb_public_1b.id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "main" {
  name     = "alb-for-crud-servers"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/healthz"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
  }
}

resource "aws_lb_target_group_attachment" "main" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.crud_server[count.index].id
  port             = 80
}

resource "aws_lb_listener" "forward_crud_server" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "redirect_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#create keypair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#based on keypair create self-signed TLS in PEM format 
resource "tls_self_signed_cert" "main" {
  private_key_pem = tls_private_key.main.private_key_pem
  
  subject {
    common_name  = var.common_name
    organization = var.organization
  }

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "cert_signing",
  ]
}

#import key in PEM format into AWS ACM service
resource "aws_acm_certificate" "main" {
  private_key      = tls_private_key.main.private_key_pem
  certificate_body = tls_self_signed_cert.main.cert_pem
}