resource "aws_instance" "crud_server" {
  count                  = var.instance_count
  ami                    = "ami-03e08697c325f02ab"
  instance_type          = "t2.micro"
  subnet_id              = element(aws_subnet.ec2_public.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.app_owner.id
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  tags = {
    Name        = "VM-${var.project_name}${count.index}"
    Environment = var.environment
  }
}

resource "aws_key_pair" "app_owner" {
  key_name   = "${var.project_name}-terraform"
  public_key = var.public_key
}
