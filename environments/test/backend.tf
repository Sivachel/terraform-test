terraform {
  backend "s3" {
    bucket = "logaraj-arenko-terraform-state"
    key    = "arenko/test/terraform.tfstate"
    region = "eu-west-2"
    profile = "test"
    use_lockfile = true
    encrypt = true
  }
}