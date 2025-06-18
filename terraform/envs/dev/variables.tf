variable "env" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

### GCP specific variables ###
variable "credentials" {
  description = "My GCP Credentials"
  default     = "./keys/gcp_keys_dev.json"
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

variable "zone" {
  description = "Project Zone"
  type        = string
  default     = "us-west1-a"
}

variable "app_name" {
  description = "Application Name"
  type        = string
  default     = "sf-crime-stats"
}

variable "docker_image" {
  description = "The docker image to deploy to Cloud Run."
  type        = string
  default     = "kdayno/sf-crime-stats:latest"
}
variable "container_cpu" {
  description = "Container cpu"
  type        = string
  default     = "2000m"
}

variable "container_memory" {
  description = "Container memory"
  type        = string
  default     = "2G"
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  default     = "mageuser"
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
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

variable "domain" {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
  default     = ""
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = false
}