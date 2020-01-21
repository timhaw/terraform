terraform {
  backend "s3" {
    bucket = "terraform-state-intercress"
    key    = "terraform/docker"
  }
}
