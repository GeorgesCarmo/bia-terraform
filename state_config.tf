terraform {
  backend "s3" {
    bucket = "bucket-bia-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "bia-tf"
  }
}

/*terraform {
  backend "local" {
    
  }
}*/