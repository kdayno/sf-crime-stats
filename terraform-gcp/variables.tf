# keys.json file is generated after creating a service account on GCP
variable "credentials" {
  description = "My GCP Credentials"
  default     = "./keys/keys.json"
}

variable "project" {
  description = "Project Name"
  default     = "sf-crime-stats-440500"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "region" {
  description = "Project Region"
  default     = "us-central1"
}
