terraform {
  required_version = ">= 1.4.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  # Authentication: recommend using a dedicated Terraform service account (keyless preferred via Workload Identity / Cloud Build); if using a JSON key, store it outside the repo.
  credentials = file(var.credentials_file) != "" ? file(var.credentials_file) : null
}

variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}
variable "credentials_file" {
  type    = string
  default = ""
}
