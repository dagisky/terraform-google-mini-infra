variable "project_id" {
  description = "GCP project id"
  type        = string
  default     = "skeleton-infra"
}

variable "region" {
  description = "Default region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "Location/region for multi-regional services like GKE and Cloud SQL"
  type        = string
  default     = "us-central1"
}

variable "env" {
  description = "Environment name used for naming resources"
  type        = string
  default     = "dev"
}

locals {
  name_prefix = "${var.env}-${var.project_id}"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

