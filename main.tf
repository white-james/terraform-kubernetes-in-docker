# Create a cluster
resource "kind_cluster" "default" {
  for_each = toset(var.environments)
    name = join("-", [each.value, "cluster"])
    wait_for_ready = true

    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"

 # Only add port mappings if the environment is "dev"
      dynamic "extra_port_mappings" {
        for_each = each.key == "dev" ? [80, 443] : []
        content {
          container_port = extra_port_mappings.value
          host_port      = extra_port_mappings.value
        }
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
  version    = "9.4.15" # Use the latest stable version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  
  depends_on = [ kubernetes_namespace_v1.argocd ]
}


