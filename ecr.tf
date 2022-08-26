resource "aws_ecr_repository" "edgecontent_ecr" {
  name                 = "edgecontent_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


