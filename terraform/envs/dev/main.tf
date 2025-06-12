module "gcp" {
    source = "../../modules/gcp"
    env = var.env
    credentials = var.credentials
    project_name = var.project_name
    location = var.location
    region = var.region
}

module "dbtcloud" {
    source = "../../modules/dbtcloud"
    env = var.env
    dbt_account_id = var.dbt_account_id
    dbt_token = var.dbt_token
    dbt_host_url = var.dbt_host_url
    gcp_project_id = var.gcp_project_id
    private_key_id = var.private_key_id
    private_key = var.private_key
    client_email = var.client_email
    client_id = var.client_id
    auth_uri = var.auth_uri
    token_uri = var.token_uri
    auth_provider_x509_cert_url = var.auth_provider_x509_cert_url
    client_x509_cert_url = var.client_x509_cert_url
}
