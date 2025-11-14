variable "project_id" { type = string }
variable "name_prefix" { type = string }    # ex: "health-patient-prod"
variable "vpc_cidr" { type = string }       # ex: "10.10.0.0/16"
variable "subnets" {
  type = list(object({
    name        = string
    region      = string
    cidr        = string
    description = optional(string)
  }))
}
variable "shared_vpc_host" {
  type = bool
  default = false
}
variable "enable_private_google_access" { type = bool; default = true }
