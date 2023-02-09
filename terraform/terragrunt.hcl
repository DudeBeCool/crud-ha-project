remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "crud-app-tfstate"
    region         = "eu-central-1"
    dynamodb_table = "crud-app-tfstate-state-lock"
    key            = "terraform-state/terraform.tfstate"
  }
}
