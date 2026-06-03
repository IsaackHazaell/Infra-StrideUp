resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

resource "aws_db_instance" "postgres" {
  identifier = var.identifier

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids

  publicly_accessible = false
  skip_final_snapshot = var.skip_final_snapshot

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection

  tags = merge(var.tags, {
    Name = var.identifier
  })
}