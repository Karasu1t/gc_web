# GKE Cluster
resource "google_container_cluster" "cluster" {
  name     = "${var.environment}-${var.project}-cluster"
  location = var.gcp_region

  enable_autopilot = true

  initial_node_count = 1

  networking_mode = "VPC_NATIVE"
  network         = var.vpc_network
  subnetwork      = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.svc_range_name
  }

  deletion_protection = false
}

#Standardモードで構築する際はコメント外す
#
# #Node Pool
# resource "google_container_node_pool" "node_pool" {
#   name     = "${var.environment}-${var.project}-node-pool"
#   location = var.gcp_region
#   cluster  = google_container_cluster.cluster.name

#   node_config {
#     machine_type = "e2-medium"
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#     ]
#     service_account = google_service_account.gke_node_sa.email
#     labels = {
#       env = var.environment
#     }
#   }

#   initial_node_count = 2
# }

# #ServiceAccount
# resource "google_service_account" "gke_node_sa" {
#   account_id = "gke-node"
# }

# resource "google_project_iam_member" "node_sa_roles" {
#   project = var.project
#   for_each = toset([
#     "roles/container.nodeServiceAccount",
#     "roles/logging.logWriter",
#     "roles/monitoring.metricWriter",
#   ])
#   role   = each.key
#   member = "serviceAccount:${google_service_account.gke_node_sa.email}"
# }
