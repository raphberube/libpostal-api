#
# Required environment variables : 
#   - GOOGLE_APPPLICATION_CREDENTIALS
#
#


terraform {
  required_providers {
    google = {
      # using beta for Cloud Build GitHub
      source = "hashicorp/google-beta"
      version = "3.46.0"
    }
  }
}



resource "google_service_account" "libpostal-api" {
  account_id   = "libpostal-api"
}

resource "google_project_service" "enable_cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_cloud_run_service" "default" {
  location                   = "northamerica-northeast1"
  name                       = "libpostal-api"
  project                    = var.project_id
  template {
        spec {
            container_concurrency = 0
            service_account_name  = "libpostal-api@${var.project_id}.iam.gserviceaccount.com"
            timeout_seconds       = 30

            containers {
                args    = []
                command = []
                image   = "gcr.io/${var.project_id}/libpostal-api:latest"

                env {
                    name  = "PROJECT_ID"
                    value = var.project_id
                }

                ports {
                    container_port = 8080
                }

                resources {
                    limits   = {
                        "cpu"    = "1000m"
                        "memory" = "256Mi"
                    }
                    requests = {}
                }
            }
        }
  }
}

output "url" {
  value = google_cloud_run_service.default.status[0].url
}