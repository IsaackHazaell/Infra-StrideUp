module "network" {
  source = "../../modules/network"

  name = "strideup-prod-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name = "strideup-prod-vpc"
  }
}

module "security" {
  source = "../../modules/security"

  vpc_id = module.network.vpc_id
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "strideup-prod-app"
}

module "secrets" {
  source = "../../modules/secrets"

  name_prefix = "strideup/prod"
  db_username = "strideup"
  db_name     = "strideup"

  tags = {
    Name = "strideup-prod-secrets"
  }
}

module "database" {
  source = "../../modules/database"

  identifier = "strideup-prod-postgres"

  db_name  = "strideup"
  username = "strideup"
  password = module.secrets.db_password

  subnet_ids         = module.network.private_subnets
  security_group_ids = [module.security.rds_sg_id]

  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  engine_version          = "16.3"
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "strideup-prod-postgres"
  }
}