# ECR
resource "aws_ecr_repository" "this" {
  for_each = toset(["frontend", "backend"])

  name                 = "${var.project}-${var.environment}-${each.key}"
  image_tag_mutability = "IMMUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-${each.key}-ecr"
  }
}

# ECR LIFECYCLE POLICY
resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
