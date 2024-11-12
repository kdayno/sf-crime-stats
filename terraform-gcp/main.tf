terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.32.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "sf-crime-bucket" {
  name          = "sf-crime-stats-terra-bucket"
  location      = var.location
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

resource "google_bigquery_dataset" "sf-crime-bq-dataset" {
  dataset_id                 = "sf_crime_stats"
  delete_contents_on_destroy = true
}
