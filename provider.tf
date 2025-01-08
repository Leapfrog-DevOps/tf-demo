terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.0"
    }
  }
}

# default provider to N. Virginia i.e. us-east-1
provider "aws" {
  region = "us-east-1"
}
