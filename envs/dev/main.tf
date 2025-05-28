# VPC 
module "network" {
  source      = "../../modules/network"
  id          = local.id
  project     = local.project
  environment = local.environment
  gcp_region  = local.gcp_region
}

# GKE 
module "gke" {
  source      = "../../modules/gke"
  project     = local.project
  environment = local.environment
  gcp_region  = local.gcp_region

  vpc_network    = module.network.vpc_network
  subnet_name    = module.network.subnet_name
  pod_range_name = module.network.project_pod_range_name
  svc_range_name = module.network.project_svc_range_name
}

# Artifactory Registry
module "artifactregistry" {
  source      = "../../modules/artifactregistry"
  project     = local.project
  environment = local.environment
  gcp_region  = local.gcp_region
}
