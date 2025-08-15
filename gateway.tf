# Minimal API Gateway with OpenAPI that requires Identity Platform JWT for auth.
# Requests are routed to the GKE Ingress IP. For production, place a stable backend.

locals {
  openapi_template = file("${path.module}/openapi/openapi.yaml")
  rendered_openapi = templatefile("${path.module}/openapi/openapi.yaml.tmpl", {
    project_id = var.project_id
    backend_url = (try(kubernetes_ingress_v1.hello.status[0].load_balancer[0].ingress[0].ip, null) != null
      ? "http://${kubernetes_ingress_v1.hello.status[0].load_balancer[0].ingress[0].ip}"
      : "http://example.com")
  })
}

resource "local_file" "openapi_rendered" {
  content  = local.rendered_openapi
  filename = "${path.module}/openapi/openapi.rendered.yaml"
}

resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id = "${local.name_prefix}-api"
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider    = google-beta
  api      = google_api_gateway_api.api.api_id
  api_config_id = "${var.env}-v1"

  openapi_documents {
    document {
      path     = local_file.openapi_rendered.filename
      contents = filebase64(local_file.openapi_rendered.filename)
    }
  }
  depends_on = [google_project_service.services]
}

resource "google_api_gateway_gateway" "gw" {
  provider    = google-beta
  gateway_id   = "${local.name_prefix}-gw"
  api_config   = google_api_gateway_api_config.api_cfg.id
  region       = var.region
}

output "api_gateway_default_url" {
  value = google_api_gateway_gateway.gw.default_hostname
}

