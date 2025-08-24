data "aws_caller_identity" "current" {}
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals { type = "Federated", identifiers = [aws_iam_openid_connect_provider.github.arn] }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}
resource "aws_iam_role" "gha_oidc" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}
data "aws_iam_policy_document" "ecr_limited" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages"
    ]
    resources = [var.ecr_repo_arn]
  }
}
resource "aws_iam_policy" "ecr" { name = "${var.role_name}-ecr", policy = data.aws_iam_policy_document.ecr_limited.json }
resource "aws_iam_role_policy_attachment" "attach_ecr" { role = aws_iam_role.gha_oidc.name, policy_arn = aws_iam_policy.ecr.arn }
output "role_arn" { value = aws_iam_role.gha_oidc.arn }
