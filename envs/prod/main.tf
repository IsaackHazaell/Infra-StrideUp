data "aws_ami" "ubuntu_arm64" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

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

  enable_nat_gateway = false
  single_nat_gateway = false

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

module "ec2" {
  source = "../../modules/ec2"

  name          = "strideup-prod-app"
  ami_id        = data.aws_ami.ubuntu_arm64.id
  instance_type = "t4g.micro"

  subnet_id          = module.network.public_subnets[0]
  security_group_ids = [module.security.ec2_sg_id]

  key_name = ""

  tags = {
    Name = "strideup-prod-app"
  }
}

module "route53" {
  source = "../../modules/route53"

  zone_name = "strideup.club"

  records = {
    root = {
      name    = "strideup.club"
      type    = "A"
      ttl     = 300
      records = [module.ec2.public_ip]
    }

    admin = {
      name    = "admin.strideup.club"
      type    = "A"
      ttl     = 300
      records = [module.ec2.public_ip]
    }

    wildcard = {
      name    = "*.strideup.club"
      type    = "A"
      ttl     = 300
      records = [module.ec2.public_ip]
    }
  }
}