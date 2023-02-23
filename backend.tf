terraform {
  backend "s3" {
    bucket = "infra-structure-tf"
    key    = "terraform"
    region = "ap-southeast-1"
  }

}