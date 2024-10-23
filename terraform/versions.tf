terraform {
  required_version = "~> 5.72.1"
  backend "s3" {
    bucket         = "1234-gitops-tf-backend-1234"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "GitopsTerraformLocks"
  }
}
