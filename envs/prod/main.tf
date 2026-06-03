module "network" {
  source = "../../modules/network"

  name = "strideup-prod-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a"
  ]

  public_subnets = [
    "10.0.1.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24"
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