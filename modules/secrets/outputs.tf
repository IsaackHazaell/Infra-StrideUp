output "db_secret_arn" {
  value = aws_secretsmanager_secret.db.arn
}

output "db_secret_name" {
  value = aws_secretsmanager_secret.db.name
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}