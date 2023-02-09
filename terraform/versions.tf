terraform {
  required_version = ">= 1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.19"
    }
  }

  backend "s3" {
    encrypt = true
    bucket = "crud-app-tfstate"
    region         = "eu-central-1"
    dynamodb_table = "crud-app-tfstate-state-lock"
    key            = "terraform-state/terraform.tfstate"
  }
}
