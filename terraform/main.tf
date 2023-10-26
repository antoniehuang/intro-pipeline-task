terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.2"
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "intro-pipeline-task-source-terraform"

  tags = {
    project_name = "Introductory Pipeline Task"
  }
}
