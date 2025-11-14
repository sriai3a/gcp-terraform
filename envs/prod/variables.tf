variable "project_id" {
  description = "GCP project id for this environment"
  type        = string
}

variable "name_prefix" {
  description = "prefix used in resource names (e.g., health-patient-prod)"
  type        = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnets" {
  type = list(object({
    name   = string
    region = string
    cidr   = string
  }))
  default = [
    { name = "app-us", region = "us-central1", cidr = "10.10.1.0/24" },
    { name = "app-eu", region = "europe-west1", cidr = "10.10.2.0/24" },
  ]
}

variable "kms_key_name" {
  description = "Full KMS key resource name for CMEK (projects/*/locations/*/keyRings/*/cryptoKeys/*)"
  type        = string
}

variable "db_root_password" {
  description = "Cloud SQL root password — prefer to load via CI secret; set as sensitive here for example"
  type        = string
  sensitive   = true
}

variable "bucket_admins" {
  type    = list(string)
  default = []
}

# VPC Service Controls: requires an existing Access Policy (org-level)
variable "access_policy_id" {
  description = "Access Context Manager Access Policy ID (org-level) - e.g., 123456789012"
  type        = string
  default     = ""
}

# Binary Authorization: attestor public key (PEM) or external reference
variable "binauth_attestor_pubkey" {
  description = "Public key content (PEM) used to create Binary Authorization attestor. Leave empty to create attestor manually."
  type        = string
  default     = ""
}

variable "cloudrun_service_account" {
  description = "Service account email used by Cloud Run services"
  type        = string
}
