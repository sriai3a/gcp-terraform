variable "project_id" {}
variable "instance_name" {}
variable "region" {}
variable "database_version" { default = "POSTGRES_14" }
variable "tier" { default = "db-custom-1-3840" }
variable "root_password" { type = string }
variable "kms_key_name" { type = string } # CMEK

resource "google_sql_database_instance" "db" {
  name             = var.instance_name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  settings {
    tier = var.tier
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.private_network_self_link # supply VPC self link
      require_ssl     = true
      authorized_networks = []
    }

    location_preference {
      zone = var.preferred_zone
    }

    data_cache_enabled = false
  }

  disk_encryption_configuration {
    kms_key_name = var.kms_key_name
  }

  deletion_protection = true
}

resource "google_sql_user" "admin" {
  instance = google_sql_database_instance.db.name
  name     = "db_admin"
  password = var.root_password
}
