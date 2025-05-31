resource "aws_ecr_repository" "frontend" {
  name = "${var.name_prefix}-frontend"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

resource "aws_ecr_repository" "backend" {
  name = "${var.name_prefix}-backend"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}