output "ecr_repository_url" {
  description = "ECR repository URL for the Stride Up app"
  value = module.ecr.repository_url
}