variable "namespace" {
  description = "Name of the Kubernetes namespace"
  type        = string
  default     = "cipher"
}

variable "name" {
  description = "Name of the ipfs service"
  type        = string
  default     = ""
}

variable "ipfs_cluster_image" {
  description = "Image URL for ipfs"
  type        = string
  default     = "ipfs/ipfs-cluster:latest"
}

variable "user" {
  description = "Default username of the ipfs"
  type        = string
  default     = "ipfs_user"
}

variable "password" {
  description = "Default password of the ipfs"
  type        = string
  default     = "hjkaajKBJ!$%675oajbi"
}

variable "type" {
  description = "Exposed type of service"
  type        = string
  default     = "ClusterIP"
}

variable "external_ips" {
  description = "List of external IPs"
  type        = list
  default     = []
}

variable "volume_names" {
  type = list
  default = ["ipfs-node1", "ipfs-node2", "ipfs-node3"]
}

variable "ports" {
  type = list(object({
    protocol = string
    port = number
    name = string
  }))
  description = "Specify the ctl and api ports."
}

variable "volume_mounts" {
  description = "Volume Mounts of the ipfs"
  type        = list
  default     = [
    {
      mount_path = "/data",
      name = "ipfs-data",
      sub_path =  "ipfs-pvc/ipfs-vol"
    },
    {
      mount_path = "/staging",
      name = "vol-ipfs-vol",
      sub_path =  "ipfs-pvc/ipfs-vol/staging"
    }
  ]
}

variable "image_pull_secrets" {
  description = "Image Pull secret for images"
  type        = list
  default     = [{
      name = "secret"
  }]
}

variable "volumes" {
  description = "Volume Mounts of the ipfs "
  type        = list(object({
      name = string,
      persistent_volume_claim = object({
          claim_name = string
      }),
      secret = object({
          secret_name = string
      })
  }))
  default     = [
    {
      name =  "ipfs-data",
      persistent_volume_claim = {
        claim_name = "pvcforcipher"
      },
      host_path = null,
      secret = null
    }
  ]
}