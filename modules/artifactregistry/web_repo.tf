resource "google_artifact_registry_repository" "repo" {
  provider      = google
  location      = var.gcp_region
  repository_id = "${var.environment}-${var.project}-web-repo"
  format        = "DOCKER"
}
