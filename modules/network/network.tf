#VPC
resource "google_compute_network" "vpc_network" {
  project                 = var.id
  name                    = "${var.environment}-${var.project}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

#Subnet(private)
resource "google_compute_subnetwork" "private_subnet_gke_project" {
  name          = "${var.environment}-${var.project}-private-subnet"
  ip_cidr_range = "10.0.0.0/20"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "${var.environment}-${var.project}-iprange-pod"
    ip_cidr_range = "10.10.0.0/16"
  }
  secondary_ip_range {
    range_name    = "${var.environment}-${var.project}-iprange-svc"
    ip_cidr_range = "10.20.0.0/20"
  }
  secondary_ip_range {
    range_name    = "${var.environment}-${var.project}-iprange-argopod"
    ip_cidr_range = "10.30.0.0/16"
  }
  secondary_ip_range {
    range_name    = "${var.environment}-${var.project}-iprange-argosvc"
    ip_cidr_range = "10.40.0.0/20"
  }
}
