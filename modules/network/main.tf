resource "google_compute_network" "vpc" {
  name                    = "${var.name_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "Custom VPC for ${var.name_prefix} (HIPAA-sensitive)"
  routing_mode            = "GLOBAL"
}

# Create subnets per supplied list
resource "google_compute_subnetwork" "subnets" {
  for_each = { for s in var.subnets : s.name => s }
  name          = "${var.name_prefix}-${each.key}"
  project       = var.project_id
  region        = each.value.region
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = each.value.cidr
  private_ip_google_access = var.enable_private_google_access
  description   = coalesce(each.value.description, "Subnet ${each.key}")
  # enable_flow_logs = true # helpful for auditing (cost/retention must be managed)
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Optionally create a serverless VPC access connector for Cloud Run -> private resources
resource "google_vpc_access_connector" "serverless_connector" {
  count    = 1
  name     = "${var.name_prefix}-serverless-connector"
  project  = var.project_id
  region   = var.subnets[0].region
  network  = google_compute_network.vpc.name
  ip_cidr_range = "10.8.0.0/28" # small /28 for connector
}
