variable "project_id" {}
variable "name_prefix" {}
variable "location" { default = "US" }
variable "kms_key_name" { type = string } # full KMS resource name or resource id

resource "google_storage_bucket" "phi_bucket" {
  name     = "${var.name_prefix}-phi-bucket"
  project  = var.project_id
  location = var.location
  force_destroy = false

  uniform_bucket_level_access = true
  versioning { enabled = false }

  encryption {
    default_kms_key_name = var.kms_key_name
  }

  lifecycle_rule {
    action { type = "Delete" }
    condition { age = 365 } # example retention policy; ensure this matches legal/retention policy
  }

  labels = {
    environment = var.name_prefix
    classification = "PHI"
  }
}

# Bucket IAM should be tightly scoped; do not give broad roles to users
resource "google_storage_bucket_iam_binding" "phi_bucket_access" {
  bucket = google_storage_bucket.phi_bucket.name
  role   = "roles/storage.objectAdmin" # adjust per-service; prefer bindings per service account
  members = var.bucket_admins
}
