output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "public_subnet" {
  value = google_compute_subnetwork.public.name
}

output "private_subnet" {
  value = google_compute_subnetwork.private.name
}

output "gke_name" {
  value = google_container_cluster.primary.name
}

output "ingress_ip" {
  description = "Ingress external IP once provisioned"
  value       = try(kubernetes_ingress_v1.hello.status[0].load_balancer[0].ingress[0].ip, null)
}

output "gcs_bucket" {
  value = google_storage_bucket.app_bucket.name
}

output "cloudsql_connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

