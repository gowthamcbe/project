required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "s3-statefile-terraform"
    key    = "zomoto/terraform.tfstate"
    region = "ap-south-1"
  }

}


provider "aws" {
  region = var.aws_region
}


