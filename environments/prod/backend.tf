terraform {
  backend "s3" {
    bucket = "logaraj-arenko-terraform-state"
    key    = "arenko/prod/terraform.tfstate"
    region = "eu-west-2"
    profile = "prod"
    use_lockfile = true
    encrypt = true
  }
}