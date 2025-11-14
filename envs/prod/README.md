# health-patient - prod environment wiring


This folder contains Terraform wiring for the `prod` environment of the `health-patient` GCP setup.


## Pre-requisites (manual / org-level)


1. **Sign Google BAA** — Ensure your organization has signed the Google BAA before storing or processing PHI on GCP.
2. **Create Access Policy (Access Context Manager)** (if you plan to use VPC Service Controls)
- An org admin should create an Access Policy and provide its numeric id for `access_policy_id`.
3. **Create KMS key ring and crypto key** for CMEK and provide the full resource name in `kms_key_name`.
4. **Create TF state bucket** (the backend bucket) with CMEK and restricted IAM. The script `enable-apis.sh` will enable required APIs but does not create the state bucket.
5. **Prepare Binary Authorization attestor key** (optional): if you want Binary Authorization, generate a signing key or use KMS and provide a public key PEM.


## Quick setup steps


1. Set variables in `envs/prod/terraform.tfvars` (do NOT commit secrets). Use `terraform.tfvars` or provide via CLI.
2. Run the helper to enable required APIs:


```bash
bash ./enable-apis.sh <PROJECT_ID>