terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53.0, < 6.0.0"
    }
  }
}
provider "google" {
  credentials = file(var.credentials)
  project     = var.project_name
  region      = var.region
}
provider "google-beta" {
  credentials = file(var.credentials)
  project = var.project_name
  region  = var.region
}

resource "google_storage_bucket" "sf-crime-bucket" {
  name          = "sf-crime-stats-terra-bucket-kd-${var.env}"
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
  dataset_id                 = "sf_crime_stats_${var.env}"
  delete_contents_on_destroy = true
}

# #############################################
# #               Enable API's                #
# #############################################
# Enable IAM API
resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# Enable Artifact Registry API
resource "google_project_service" "artifactregistry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Resource Manager API
resource "google_project_service" "resourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# Enable VCP Access API
resource "google_project_service" "vpcaccess" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

# Enable Secret Manager API
resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud SQL Admin API
resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

# Create the Cloud Run service
resource "google_cloud_run_service" "run_service" {
  name     = "${var.app_name}-${var.env}"
  location = var.region

  template {
    spec {
      containers {
        image = var.docker_image
        ports {
          container_port = 6789
        }
        resources {
          limits = {
            cpu    = var.container_cpu
            memory = var.container_memory
          }
        }
        env {
          name  = "FILESTORE_IP_ADDRESS"
          value = google_filestore_instance.instance.networks[0].ip_addresses[0]
        }
        env {
          name  = "FILE_SHARE_NAME"
          value = "share1"
        }
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project_name
        }
        env {
          name  = "GCP_REGION"
          value = var.region
        }
        env {
          name  = "GCP_SERVICE_NAME"
          value = var.app_name
        }
        env {
          name  = "MAGE_DATABASE_CONNECTION_URL"
          value = "postgresql://${var.database_user}:${var.database_password}@/${var.app_name}-db?host=/cloudsql/${google_sql_database_instance.instance.connection_name}"
        }
        env {
          name  = "ULIMIT_NO_FILE"
          value = 16384
        }
        env {
          name = "path_to_keyfile"
          value = "/secrets/bigquery/bigquery-credentials-${var.env}.json"
        }
        volume_mounts {
          name       = "secrets-bigquery-credentials-${var.env}"
          mount_path = "/secrets/bigquery"
        }
      }
      volumes {
        name = "secrets-bigquery-credentials-${var.env}"
        secret {
          secret_name  = "bigquery-credentials-${var.env}"
          items {
            key  = "latest"
            path = "bigquery-credentials-${var.env}"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = "1"
        "run.googleapis.com/cloudsql-instances"    = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/cpu-throttling"        = false
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.connector.id
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
      "run.googleapis.com/ingress"      = "internal-and-cloud-load-balancing"
    }
  }

  autogenerate_revision_name = true

  # Waits for the Cloud Run API to be enabled
  depends_on = [google_project_service.cloudrun]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Display the service IP
output "service_ip" {
  value = module.lb-http.external_ip
}