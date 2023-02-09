# Create security groups to controll the traffic allowed to infrastructure
resource "aws_security_group" "lb_main" {
  name        = "${var.project_name}-application-lb"
  description = "access from vpn "
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = [var.securitygroup-ingress]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-application-ec2"
  description = "access to public ec2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = [var.securitygroup-ingress]
  }

  ingress {
    protocol    = "tcp"
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = [var.securitygroup-ingress]
  }

  ingress {
    protocol        = "tcp"
    from_port       = "80"
    to_port         = "80"
    cidr_blocks     = [var.securitygroup-ingress]
    security_groups = [aws_security_group.lb_main.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for RDS
resource "aws_security_group" "rds_main" {
  name        = "${var.project_name}-postgres-public"
  description = "access to public rds instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    cidr_blocks     = ["10.0.3.0/24", "10.0.4.0/24"]
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
