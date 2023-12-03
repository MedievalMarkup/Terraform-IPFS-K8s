terraform {
  required_providers {
    kubernetes = {
      source = "registry.terraform.io/hashicorp/kubernetes"
      version = "2.13.1"
    }

  }
}


provider "kubernetes" {
  config_path    = "~/.kube/config"
}
