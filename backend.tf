# Terraform Backend Configuration local
terraform {
  backend "local" {

  }
}

## Terraform Backend Configuration S3
# terraform {
#   backend "s3" {
#     bucket = "terraform-state-bucket-unique-1234567890"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }
