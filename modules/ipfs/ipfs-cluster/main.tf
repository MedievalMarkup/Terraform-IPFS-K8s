resource "kubernetes_service_v1" "kb_cluster_ipfs_service" {

  metadata {
    name      = "${var.name}-service"
    namespace = var.namespace
    labels = {
      name = "${var.name}-service"
    }
  }

  spec {
    selector = {
      app = var.name
    }

    dynamic "port" {
      for_each = var.ports
      content {
        name = port.value["name"]
        protocol = port.value["protocol"]
        port = port.value["port"]
      }
    }
    
    type         = var.type
    external_ips = var.external_ips
  }
}

resource "kubernetes_deployment_v1" "kb_cluster_ipfs_deployment" {
  
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      name = var.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          image = var.ipfs_cluster_image
          name  = var.name
          port {
            container_port = 9094
          }
          port {
            container_port = 9096
          }
          dynamic "volume_mount" {
            for_each = var.volume_mounts
            content {
              name       = volume_mount.value["name"]
              mount_path = volume_mount.value["mount_path"]
              sub_path   = volume_mount.value["sub_path"]
            }
          }
        }
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets
          content {
            name = image_pull_secrets.value["name"]
          }
        }
        dynamic "volume" {
          for_each = var.volumes
          content {
            name = volume.value["name"]
            dynamic "persistent_volume_claim" {
              for_each = volume.value["persistent_volume_claim"] != null ? [1] : []
              content {
                claim_name = volume.value.persistent_volume_claim["claim_name"]
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_service_v1.kb_cluster_ipfs_service
  ]
}