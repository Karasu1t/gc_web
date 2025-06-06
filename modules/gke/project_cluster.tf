# GKEクラスタ (Standardモード)
resource "google_container_cluster" "cluster" {
  name     = "${var.environment}-${var.project}-cluster"
  location = var.gcp_region

  networking_mode = "VPC_NATIVE"
  network         = var.vpc_network
  subnetwork      = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.svc_range_name
  }

  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Node Pool (Standardモードでノードを作成)
resource "google_container_node_pool" "node_pool" {
  name     = "${var.environment}-${var.project}-node-pool"
  location = var.gcp_region
  cluster  = google_container_cluster.cluster.name

  node_config {
    machine_type    = "e2-medium"
    disk_type       = "pd-standard"
    disk_size_gb    = 50
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_node_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = {
      env = var.environment
    }
  }

  initial_node_count = 1
}

# argocdクラスタも同様にStandardモードにする場合
resource "google_container_cluster" "argocd" {
  name     = "${var.environment}-${var.project}-argocd"
  location = var.gcp_region

  networking_mode = "VPC_NATIVE"
  network         = var.vpc_network
  subnetwork      = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.argopod_range_name
    services_secondary_range_name = var.argosvc_range_name
  }

  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "argocd_node_pool" {
  name     = "${var.environment}-${var.project}-argocd-node-pool"
  location = var.gcp_region
  cluster  = google_container_cluster.argocd.name

  node_config {
    machine_type    = "e2-medium"
    disk_type       = "pd-standard"
    disk_size_gb    = 50
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_node_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    labels = {
      env = var.environment
    }
  }

  initial_node_count = 1
}

# Service Account(GKEノードのVM用)
resource "google_service_account" "gke_node_sa" {
  account_id   = "gke-node"
  display_name = "GKE Node Service Account"
}

resource "google_project_iam_member" "node_sa_roles" {
  project = var.id

  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  role   = each.key
  member = "serviceAccount:${google_service_account.gke_node_sa.email}"
}
