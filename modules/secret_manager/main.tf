variable "project_id" { type = string }
variable "name_prefix" { type = string }
variable "secrets" {
  type = list(object({
    id          = string
    description = optional(string)
    payload     = optional(string) # optional: avoid embedding secrets, use CI to create secret versions instead
  }))
  default = []
}
variable "secret_accessor_principals" {
  type = list(string)
  default = []
}

resource "google_secret_manager_secret" "secrets" {
  for_each = { for s in var.secrets : s.id => s }

  secret_id = "${var.name_prefix}-${each.key}"
  project   = var.project_id

  replication {
    automatic = true
  }

  labels = {
    classification = "PHI"
    environment    = var.name_prefix
  }

  depends_on = []
}

# Optionally create a secret version from payload (only for examples; avoid weak security)
resource "google_secret_manager_secret_version" "secret_versions" {
  for_each = { for s in var.secrets : s.id => s if can(s.payload) && s.payload != "" }

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.payload
}

# Grant secretAccessor to each principal for each secret
resource "google_secret_manager_secret_iam_binding" "secret_access_binding" {
  for_each = { for s in google_secret_manager_secret.secrets : s.secret_id => s }

  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = var.secret_accessor_principals
}
