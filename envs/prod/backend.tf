terraform {
  backend "s3" {
    bucket         = "strideup-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "strideup-terraform-locks"
    encrypt        = true
    profile        = "strideup-prod"
  }
}