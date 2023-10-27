terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.2"

  backend "s3" {
    bucket         = "intro-pipeline-task-infra-bucket"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "intro-pipeline-task-infra-lockid"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
