terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }

  required_version = "~> 1.1.7"
}

provider "google" {
  project = local.workspace["project"]
  region  = "us-central1"
}

data "google_client_config" "default" {}

data "google_container_cluster" "default" {
  name     = local.workspace["cluster"]
  location = "us-central1-a"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}
