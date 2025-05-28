terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.36.1"
    }
  }
}

provider "google" {
  # Configuration options
  project     = local.id
  region      = local.gcp_region
  zone        = local.gcp_zone
  credentials = "../../keys.json"
}
