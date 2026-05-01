terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.33.0"
    }
  }
  backend "s3" {
    bucket = "tf-remotestate-mani-dev"
    key    = "terraform-eks-sg"
    region = "us-east-1"
    use_lockfile = true # This is the default behavior now
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}