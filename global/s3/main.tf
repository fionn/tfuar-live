provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 3.9.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-tfuar"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
