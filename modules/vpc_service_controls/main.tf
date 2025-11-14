variable "access_policy_id" { type = string }
variable "title" { type = string }
variable "project_number" { type = string }
variable "restricted_services" {
  type = list(string)
  default = [
    "storage.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudkms.googleapis.com",
  ]
}

# Note: google_access_context_manager_service_perimeter requires provider configured with org-level credentials
resource "google_access_context_manager_service_perimeter" "perimeter" {
  count = length(var.access_policy_id) > 0 ? 1 : 0

  name        = "${var.title}-perimeter"
  parent      = "accessPolicies/${var.access_policy_id}"
  title       = "${var.title}-perimeter"
  description = "Service Perimeter protecting PHI resources for ${var.title}"

  status {
    restricted_services = var.restricted_services
    resources = [
      "projects/${var.project_number}"
    ]
    access_levels = [] # optional: provide access levels if you have context-aware access lists
  }

  type = "PERIMETER_TYPE_REGULAR"
}
