resource "kubernetes_job_v1" "kb_setup_job" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      name = var.name
    }
  }

  spec {
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        container {
          image   = var.image
          name    = var.name
          command = var.command
          // command = ["/bin/sh", "-ec", "sleep 2h"]
          # command = ["/bin/sh", "-ec", "sleep 30m"]
          dynamic "volume_mount" {
            for_each = var.volume_mounts
            content {
              name       = volume_mount.value["name"]
              mount_path = volume_mount.value["mount_path"]
              sub_path   = volume_mount.value["sub_path"]
            }
          }
        }
        restart_policy = "Never"
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

            dynamic "secret" {
              for_each = volume.value["secret"] != null ? [1] : []
              content {
                secret_name = volume.value.secret["secret_name"]
              }
            }
          }
        }
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = false
}
