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
  name                     = "sf-crime-stats"
  dbt_project_subdirectory = "/dbt"
}

resource "dbtcloud_global_connection" "bigquery" {
  name = "bq-connection"
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

resource "dbtcloud_repository" "github_repo" {
  project_id             = dbtcloud_project.dbt_project.id
  remote_url             = "git@github.com:kdayno/sf-crime-stats.git"
  github_installation_id = 48813291 # This value can be obtained from within GitHub (Settings>Integrations>Applications)
  git_clone_strategy     = "github_app"
}

resource "dbtcloud_project_repository" "github_repo_ui" {
  project_id    = dbtcloud_project.dbt_project.id
  repository_id = dbtcloud_repository.github_repo.repository_id
}

resource "dbtcloud_bigquery_credential" "credential_dev" {
  project_id  = dbtcloud_project.dbt_project.id
  dataset     = "sf_crime_dataset"
  num_threads = 16
  is_active   = true
}
resource "dbtcloud_environment" "dbtcloud_dev" {
  dbt_version       = "versionless"
  name              = "Dev"
  project_id        = dbtcloud_project.dbt_project.id
  type              = "development"
  credential_id     = dbtcloud_bigquery_credential.credential_dev.credential_id
  connection_id     = dbtcloud_global_connection.bigquery.id
  is_active         = true
  use_custom_branch = true
  custom_branch     = "feature/terraform-setup"
}

# resource "dbtcloud_environment" "dbtcloud_stg" {
#   dbt_version     = "versionless"
#   name            = "Dev"
#   project_id      = dbtcloud_project.dbt_project.id
#   type            = "deployment"
#   deployment_type = "staging"
#   credential_id   = dbtcloud_bigquery_credential.credential_dev.credential_id
#   connection_id   = dbtcloud_global_connection.bigquery.id
#   is_active       = true

# }


