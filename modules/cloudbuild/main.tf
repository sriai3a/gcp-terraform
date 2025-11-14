variable "project_id" {}
variable "service_account_email" {}
variable "substitutions" { type = map(string); default = {} }

# A minimal Cloud Build service account and IAM binding
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cb-${var.project_id}"
  project      = var.project_id
  display_name = "Cloud Build Service Account for ${var.project_id}"
}

# Give Cloud Build SA minimal roles needed: Cloud Run Admin (deploy), Storage Object Admin for GCR/GCS, Service Account User
resource "google_project_iam_member" "cloudbuild_run_deployer" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}
