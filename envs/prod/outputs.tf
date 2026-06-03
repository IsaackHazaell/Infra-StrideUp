output "ecr_repository_url" {
  description = "ECR repository URL for the Stride Up app"
  value       = module.ecr.repository_url
}

output "database_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.database.db_instance_endpoint
}

output "database_name" {
  description = "Database name"
  value       = module.database.db_name
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}