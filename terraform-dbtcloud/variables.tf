# All GCP values can be obtained from the credentials .json file that is generated when creating a service account on GCP
variable "dbt_account_id" {
  type = number
}
variable "dbt_token" {
  type = string
}

variable "dbt_host_url" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "private_key_id" {
  type = string
}

variable "private_key" {
  type = string
}

variable "client_email" {
  type = string
}

variable "client_id" {
  type = string
}

variable "auth_uri" {
  type = string
}

variable "token_uri" {
  type = string
}

variable "auth_provider_x509_cert_url" {
  type = string
}

variable "client_x509_cert_url" {
  type = string
}


