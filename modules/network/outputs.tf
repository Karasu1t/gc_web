output "vpc_network" {
  value = google_compute_network.vpc_network.name
}

output "subnet_name" {
  value = google_compute_subnetwork.private_subnet_gke_project.name
}

output "project_pod_range_name" {
  value = google_compute_subnetwork.private_subnet_gke_project.secondary_ip_range[0].range_name
}

output "project_svc_range_name" {
  value = google_compute_subnetwork.private_subnet_gke_project.secondary_ip_range[1].range_name
}

output "project_argopod_range_name" {
  value = google_compute_subnetwork.private_subnet_gke_project.secondary_ip_range[2].range_name
}

output "project_argosvc_range_name" {
  value = google_compute_subnetwork.private_subnet_gke_project.secondary_ip_range[3].range_name
}
