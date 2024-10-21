terraform {
  required_version = "~> 1.9.5"
  backend "s3" {
    bucket         = "1234-gitops-backend-2024-1234"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "GitopsTerraformLocks"
  }
}
