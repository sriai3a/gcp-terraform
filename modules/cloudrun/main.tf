variable "project_id" {}
variable "name" {}
variable "region" {}
variable "image" {}
variable "service_account" {}
variable "vpc_connector" { default = "" } # serverless connector name
variable "allow_unauthenticated" { default = false }
variable "ingress" { default = "INGRESS_TRAFFIC_INTERNAL_ONLY" } # internal only by default

resource "google_cloud_run_service" "service" {
  name     = var.name
  project  = var.project_id
  location = var.region

  template {
    spec {
      service_account_name = var.service_account
      containers {
        image = var.image
        # pass DB connection via env / secret manager
      }
      if var.vpc_connector != "" {
        container_concurrency = 80
      }
    }
  }

  traffics {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  ingress = var.ingress
}

# Allow Cloud Run to use serverless VPC connector (this is done in the Cloud Run service config; Terraform may need google_cloud_run_service_iam_member for invokers)
resource "google_cloud_run_service_iam_member" "invoker" {
  service = google_cloud_run_service.service.name
  location = var.region
  role = "roles/run.invoker"
  member = "serviceAccount:${var.service_account}" # or users as needed
}
