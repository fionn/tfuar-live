module "database" {
  source = "../../../modules/data-stores/mysql"

  db_name     = "staging"
  db_password = var.db_password
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "staging/data-stores/mysql/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
