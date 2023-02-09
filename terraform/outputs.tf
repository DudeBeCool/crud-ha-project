output "ecr_rw_access_key" {
  value = {
    access_key_id     = aws_iam_access_key.main_key.id
    access_key_secret = aws_iam_access_key.main_key.secret
  }
  sensitive = true
}

output "dns_name" {
  value = {
    crud_server_vm   = aws_instance.crud_server.*.public_dns
    alb_endpoint     = aws_lb.main.dns_name
  }
}