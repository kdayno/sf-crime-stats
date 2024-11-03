terraform {
  required_providers {
    dbtcloud = {
      source  = "dbt-labs/dbtcloud"
      version = "0.3.13"
    }
  }
}

provider "dbtcloud" {
  account_id = var.dbt_account_id
  token      = var.dbt_token
  host_url   = var.dbt_host_url
}

resource "dbtcloud_project" "dbt_project" {
  name = "sf-crime-stats"
}

resource "dbtcloud_global_connection" "bigquery" {
  name = "My BigQuery connection"
  bigquery = {
    gcp_project_id              = var.gcp_project_id
    timeout_seconds             = 1000
    private_key_id              = var.private_key_id
    private_key                 = var.private_key
    client_email                = var.client_email
    client_id                   = var.client_id
    auth_uri                    = var.auth_uri
    token_uri                   = var.token_uri
    auth_provider_x509_cert_url = var.auth_provider_x509_cert_url
    client_x509_cert_url        = var.client_x509_cert_url
  }
}

# resource "dbtcloud_repository" "github_repo" {
#   project_id             = dbtcloud_project.dbt_project.id
#   remote_url             = "git@github.com:<github_org>/<github_repo>.git"
#   github_installation_id = 9876
#   git_clone_strategy     = "github_app"
# }


// create 2 environments, one for Dev and one for Prod
// here both are linked to the same Data Warehouse connection
// for Prod, we need to create a credential as well
resource "dbtcloud_environment" "my_dev" {
  dbt_version   = "versionless"
  name          = "Dev"
  project_id    = dbtcloud_project.dbt_project.id
  type          = "development"
  connection_id = dbtcloud_global_connection.bigquery.id
}

resource "dbtcloud_bigquery_credential" "my_credential" {
  project_id  = dbtcloud_project.dbt_project.id
  dataset     = "sf_crime_dataset"
  num_threads = 16
}
