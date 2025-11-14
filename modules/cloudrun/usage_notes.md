1. Create secret(s) in Secret Manager (module above).

2. Grant the Cloud Run service account roles/secretmanager.secretAccessor.

3. In your Cloud Run container, fetch secrets at startup using the Secret Manager API (recommended) rather than putting secret values into environment variables in Terraform. Example pseudo-code for the app:

# python example
from google.cloud import secretmanager
client = secretmanager.SecretManagerServiceClient()
name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
payload = client.access_secret_version(name=name).payload.data.decode("UTF-8")

4. For convenience you can still store the secret name as an environment variable (non-sensitive) in Terraform:

resource "google_cloud_run_service" "patient_api" {
  # ...
  template {
    spec {
      containers {
        env {
          name  = "DB_ROOT_SECRET_NAME"
          value = "${module.secrets.secrets_db_name}"  # example output containing secret name
        }
      }
      service_account_name = var.service_account
    }
  }
}

This pattern keeps secret values out of state and runtime access is granted via IAM.