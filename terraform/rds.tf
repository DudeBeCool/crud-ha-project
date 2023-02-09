resource "aws_db_instance" "postgres_main" {
  identifier             = "${var.project_name}-main"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.2"
  instance_class         = "db.t3.micro"
  db_name                = "postgres"
  username               = "postgres"
  password               = var.password
  skip_final_snapshot    = true
  port                   = "5432"
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.postgres_main.name
  vpc_security_group_ids = [aws_security_group.rds_main.id]
}
