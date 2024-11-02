terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.32.0"
    }
  }
}

provider "google" {
  project     = "sf-crime-stats"
  region      = "us-central1"
}

resource "google_storage_bucket" "sf-crime-data" {
  name          = "sf-crime-stats-terra-bucket"
  location      = "US"
  force_destroy = true
  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
