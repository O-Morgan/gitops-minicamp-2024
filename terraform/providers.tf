terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Service     = "GitOps Minicamp 2024"  # Indicates the name of this project or application
      Environment = "development"           # Indicates the deployment environment (e.g., Development)
    }
  }
}
