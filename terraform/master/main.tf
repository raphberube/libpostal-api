
terraform {
  required_providers {
    google = {
      # using beta for Cloud Build GitHub
      source  = "hashicorp/google-beta"
      version = "3.46.0"
    }
    docker = {
      source = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
  }
}


provider "google" {
  region  = var.location
  project = var.project_id
}


resource "google_service_account" "libpostal-api" {
  account_id = "libpostal-api"
}

resource "google_project_service" "enable_cloud_resource_manager_api" {
  project                    = var.project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "iam" {
  project                    = var.project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "run" {
  project                    = var.project_id
  service                    = "run.googleapis.com"
  disable_dependent_services = true
}

data "google_client_config" "default" {}

output "test" {
  value = data.google_client_config.default.access_token
}

provider "docker" {
  registry_auth {
    address  = "gcr.io"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

data "docker_registry_image" "libpostal-api-image" {
  name = "gcr.io/${var.project_id}/libpostal-api"
}

data "google_container_registry_image" "libpostal-api-image-latest" {
  name    = "libpostal-api"
  project = var.project_id
  digest  = data.docker_registry_image.libpostal-api-image.sha256_digest
}

output "image_url" {
  value = data.google_container_registry_image.libpostal-api-image-latest.image_url
}

resource "google_cloud_run_service" "libpostalapi" {
  location = var.location
  name     = "libpostal-api"
  project  = var.project_id

  autogenerate_revision_name = "true"

  template {
    spec {
      container_concurrency = 1
      service_account_name  = google_service_account.libpostal-api.email
      timeout_seconds       = 30


      containers {
        args    = []
        command = []
        image   = data.google_container_registry_image.libpostal-api-image-latest.image_url

        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }

        env {
          name  = "WORKERS"
          value = 1
        }


        ports {
          container_port = 8080
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "4Gi"
          }
          requests = {}
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "url" {
  value = google_cloud_run_service.libpostalapi.status[0].url
}


resource "google_cloud_run_service_iam_member" "binding" {
  location = var.location
  project  = var.project_id
  service  = google_cloud_run_service.libpostalapi.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}