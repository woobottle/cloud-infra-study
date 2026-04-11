resource "aws_ecr_repository" "next_app" {
  name                 = "${var.project_name}/next-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}
