# Cloud Run SA minimal roles
resource "google_project_iam_member" "cr_sa_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${var.cloudrun_service_account}"
}

resource "google_project_iam_member" "cr_sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client" # allow Cloud Run to connect to private Cloud SQL
  member  = "serviceAccount:${var.cloudrun_service_account}"
}

# Cloud Build SA (assume cloudbuild service account exists)
resource "google_project_iam_member" "cloudbuild_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}
