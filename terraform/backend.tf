terraform {
  backend "s3" {
    bucket       = "econ-terraform-state-rvin"
    key          = "test-env.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
