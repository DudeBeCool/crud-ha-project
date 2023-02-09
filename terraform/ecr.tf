resource "aws_ecr_repository" "image_registry" {
  name                 = "${var.project_name}-application"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
