terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.28.0"
    }
  }

  backend "s3" {
    bucket         = "s3-tfstate-iris"
    key            = "terraform.tfstate"
    region         = "us-east-2"
 }
}

provider "aws" {
  region = "us-east-2"
}
