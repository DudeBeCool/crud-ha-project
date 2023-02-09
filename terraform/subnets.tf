# Private subnets
resource "aws_subnet" "db_private_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1a"

  tags = {
    Name        = "${var.project_name}-application-db"
    Environment = var.environment
  }
}

resource "aws_subnet" "db_private_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1b"

  tags = {
    "Name"      = "${var.project_name}-application-db"
    Environment = var.environment
  }
}

# DB subnet group
resource "aws_db_subnet_group" "postgres_main" {
  name = "${var.project_name}db-subnet-group"
  # Multiple subnets one per AZ in total (2) as RDS requirment
  subnet_ids = [aws_subnet.db_private_1a.id, aws_subnet.db_private_1b.id]

  tags = {
    Name        = "${var.project_name}-application-postgres-db"
    Environment = var.environment
  }
}

# Public subnets
resource "aws_subnet" "lb_public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name        = "${var.project_name}-application-lb"
    Environment = var.environment
  }
}

resource "aws_subnet" "lb_public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"

  tags = {
    Name        = "${var.project_name}-application-lb"
    Environment = var.environment
  }
}

resource "aws_subnet" "ec2_public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(["eu-central-1a", "eu-central-1b"], count.index)

  tags = {
    Name        = "${var.project_name}-application-ec2-${count.index}"
    Environment = var.environment
  }
}
