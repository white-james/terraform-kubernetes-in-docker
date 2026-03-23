terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  host                   = kind_cluster.default["dev"].endpoint
  client_certificate     = kind_cluster.default["dev"].client_certificate
  client_key             = kind_cluster.default["dev"].client_key
  cluster_ca_certificate = kind_cluster.default["dev"].cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = kind_cluster.default["dev"].endpoint
    client_certificate     = kind_cluster.default["dev"].client_certificate
    client_key             = kind_cluster.default["dev"].client_key
    cluster_ca_certificate = kind_cluster.default["dev"].cluster_ca_certificate
  }
}
