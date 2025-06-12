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
