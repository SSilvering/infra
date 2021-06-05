variable "gcp_credentials" {
  type        = string
  description = "Location of service account for GCP"
}

variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP Region"
}

variable "gke_regional" {
  default     = false
  description = "GCP Regional / Zonenal"
}

variable "gcp_cluster_name" {
  type        = string
  description = "GCP Cluster name"
}

variable "gke_zones" {
  type        = list(string)
  description = "List of zones for the GKE Cluster"
}

variable "gke_network" {
  type        = string
  description = "VPC Network name"
}

variable "gke_subnetwork" {
  type        = string
  description = "VPC Sub Network name"
}

variable "gke_nodepool_name" {
  type        = string
  description = "GKE Default node-pool name"
}

variable "gke_service_account_name" {
  type        = string
  description = "GKE Service Account name"
}