# Minimal Kubernetes ingress that will provision a Google Cloud HTTP(S) Load Balancer via GKE Ingress controller.
# This is a placeholder Service and Ingress for bootstrapping the external Load Balancer.

resource "kubernetes_namespace" "default_app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name      = "hello"
    namespace = kubernetes_namespace.default_app.metadata[0].name
    labels = {
      app = "hello"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "hello"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello"
        }
      }
      spec {
        container {
          name  = "hello"
          image = "us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello" {
  metadata {
    name      = "hello"
    namespace = kubernetes_namespace.default_app.metadata[0].name
    annotations = {
      "cloud.google.com/neg" = jsonencode({ ingress = true })
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.hello.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "hello" {
  metadata {
    name      = "hello"
    namespace = kubernetes_namespace.default_app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.allow-http"           = "true"
    }
  }
  spec {
    default_backend {
      service {
        name = kubernetes_service.hello.metadata[0].name
        port {
          number = 80
        }
      }
    }
  }
}

