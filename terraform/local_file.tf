#create inventory for Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/template/inventory.tpl",
    {
      hostnames          = aws_instance.crud_server.*.tags.Name
      ansible_hosts      = aws_instance.crud_server.*.public_ip
      db_public_ip       = aws_db_instance.postgres_main.endpoint
      username           = aws_db_instance.postgres_main.username
      password           = aws_db_instance.postgres_main.password
      ecr_image_endpoint = aws_ecr_repository.image_registry.repository_url
      lb_endpoint        = aws_lb.main
    }
  )
  filename = "${path.module}/../ansible/inventory.ini"
}
