# keys.json file is generated after creating a service account on GCP
variable "env" {
  description = "The environment name"
  type        = string
}

variable "credentials" {
  description = "My GCP Credentials"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "location" {
  description = "Project Location"
  type        = string
}

variable "region" {
  description = "Project Region"
  type        = string
}

variable "zone" {
  description = "Project Zone"
  type        = string
}
variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "docker_image" {
  description = "The docker image to deploy to Cloud Run."
  type        = string
}
variable "container_cpu" {
  description = "Container cpu"
  type        = string
}

variable "container_memory" {
  description = "Container memory"
  type        = string
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
}

variable "domain" {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
}