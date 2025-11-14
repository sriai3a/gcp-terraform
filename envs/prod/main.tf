provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "../../modules/network"
  project_id = var.project_id
  name_prefix = var.name_prefix
  vpc_cidr = "10.10.0.0/16"
  subnets = [
    { name = "app-eu", region = "europe-west1", cidr = "10.10.1.0/24" },
    { name = "app-us", region = "us-central1", cidr = "10.10.2.0/24" }
  ]
}

# Allocate private services access range for Cloud SQL private IP
resource "google_service_networking_connection" "private_vpc_conn" {
  network                 = module.network.vpc_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["google-sql-private-range"]
  project                 = var.project_id
}

resource "google_compute_global_address" "private_sql_range" {
  name          = "google-sql-private-range"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.network.vpc_name
  depends_on    = [module.network]
}

module "sql" {
  source = "../../modules/sql"
  project_id = var.project_id
  instance_name = "${var.name_prefix}-db"
  region = var.region
  private_network_self_link = module.network.vpc_name
  root_password = var.db_root_password
  kms_key_name = var.kms_key_name
  preferred_zone = var.zone
}

module "storage" {
  source = "../../modules/storage"
  project_id = var.project_id
  name_prefix = var.name_prefix
  kms_key_name = var.kms_key_name
  location = "US"
  bucket_admins = var.bucket_admins
}

module "cloudbuild" {
  source = "../../modules/cloudbuild"
  project_id = var.project_id
  service_account_email = var.cloudbuild_sa_email
  substitutions = {}
}
