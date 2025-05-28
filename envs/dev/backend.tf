terraform {
  backend "gcs" {
    bucket = "dev-karasuit-state-bucket"
    prefix = "terraform/state"
  }
}
