output "vpc_name" { value = google_compute_network.vpc.name }
output "subnet_self_links" {
  value = [for s in google_compute_subnetwork.subnets : s.self_link]
}
output "serverless_connector_name" {
  value = length(google_vpc_access_connector.serverless_connector) > 0 ? google_vpc_access_connector.serverless_connector[0].name : ""
}
