variable "env" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

### GCP specific variables ###
variable "credentials" {
  description = "My GCP Credentials"
  default     = "./keys/gcp-keys.json"
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "sf-crime-stats-455819"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "region" {
  description = "Project Region"
  default     = "us-west1"
}


### dbt Cloud specific variables ###
# All GCP values can be obtained from the credentials .json file that is generated when creating a service account on GCP
variable "dbt_account_id" {
  type = number
  description = "Available in dbt Cloud Account Settings. e.g. 12345678912345"
}
variable "dbt_token" {
  type = string
}

variable "dbt_host_url" {
  type = string
  description = "Available in dbt Cloud Account Settings under 'Access URL'. Ensure to append '/api' to url. e.g. https://*****.dbt.com/api"
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
