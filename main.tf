# Create a cluster
resource "kind_cluster" "default" {
    name = "dev-cluster"
    wait_for_ready = true

    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"

          extra_port_mappings {
              container_port = 80
              host_port      = 80
          }
          extra_port_mappings {
              container_port = 443
              host_port      = 443
          }
      }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  depends_on = [ kind_cluster.default ]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.4.5" # Use the latest stable version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  
  depends_on = [ kubernetes_namespace_v1.argocd ]
}


