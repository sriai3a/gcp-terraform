variable "project_id" { type = string }
variable "attestor_id" { type = string; default = "patient-attestor" }
variable "attestor_display_name" { type = string; default = "Patient Attestor" }
variable "binauth_attestor_pubkey" { type = string; default = "" }

# Enable API (if not already)
resource "google_project_service" "binaryauthorization_api" {
  project = var.project_id
  service = "binaryauthorization.googleapis.com"
}

# Attestor (only created if pubkey provided)
resource "google_binary_authorization_attestor" "attestor" {
  count = length(var.binauth_attestor_pubkey) > 0 ? 1 : 0

  project      = var.project_id
  name         = var.attestor_id
  description  = var.attestor_display_name

  user_owned_drydock_note {
    note_reference = "projects/${var.project_id}/notes/${var.attestor_id}-note" # placeholder
    public_keys {
      comment = "primary key"
      pkix_public_key {
        public_key = var.binauth_attestor_pubkey
        format     = "PEM"
      }
    }
  }
}
