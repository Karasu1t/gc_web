variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "id" {
  type = string
}

variable "vpc_network" {}
variable "subnet_name" {}
variable "pod_range_name" {}
variable "svc_range_name" {}
variable "argopod_range_name" {}
variable "argosvc_range_name" {}
