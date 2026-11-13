terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Ephemeral-EKS-Microservices"
      ManagedBy   = "Terraform"
      Environment = "Ephemeral"
      Owner       = var.owner
    }
  }
}

