resource "aws_ecr_repository" "lambda" {
  name                 = "${var.project_name}"
  image_tag_mutability = var.ecr_mutability
  force_delete         = var.ecr_force_delete

  provisioner "local-exec" {
    command = templatefile("ecr_template.tmpl", {proj_name = var.project_name, account_id = var.account_id, region = var.region})
  }
}


resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.lambda.name
  policy     = var.ecr_policy
}
