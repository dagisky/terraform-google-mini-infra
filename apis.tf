resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "artifactregistry.googleapis.com",
    "iap.googleapis.com",
    "apigateway.googleapis.com",
    "identitytoolkit.googleapis.com",
    "identityplatform.googleapis.com",
    "sqladmin.googleapis.com"
  ])

  service = each.key

  disable_on_destroy = false
}

