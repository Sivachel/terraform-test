terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "arenko/test/terraform.tfstate"
    region = "eu-west-1"
    profile = "test"
    use_lockfile = true
    encrypt = true
  }
}