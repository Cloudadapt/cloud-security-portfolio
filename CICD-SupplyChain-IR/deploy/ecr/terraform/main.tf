resource "aws_ecr_repository" "repo" {
  name = var.repository_name
  image_scanning_configuration { scan_on_push = true }
  tags = { Project = "Year3" }
}
output "repository_url" { value = aws_ecr_repository.repo.repository_url }
