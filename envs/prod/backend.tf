terraform {
  backend "gcs" {
    bucket = "tf-state-health-patient-prod"
    prefix = "envs/prod"
  }
}
