# variable "ipfs_node_image" {
#   description = "Node Image URL for IPFS"
#   type        = string
#   default     = ""
# }

# variable "ipfs_cluster_image" {
#   description = "Cluster Image URL for IPFS"
#   type        = string
#   default     = "ipfs/ipfs-cluster:latest"
# }

variable "namespace" {
  description = "namespace"
  type        = string
  default     = "ipfs"
}

variable "ipfs_name" {
  description = "Name for IPFS"
  type        = string
  default     = "-ipfs"
}

variable "type" {
  description = "type for IPFS"
  type        = string
  default     = "ClusterIP"
}

variable "setup_script" {
  description = "setup for IPFS"
  type        = string
  default     = "ipfs-setup"
}

variable "ports_of_node" {
  description = "ipfs node service port"
  type        = list(list(number))
  default     = [[4002, 5002], [6002, 7002], [8002, 9002]]
}

variable "ports_of_cluster" {
  description = "ipfs cluster service port"
  type        = list(list(number))
  default     = [[8094, 8096], [9084, 9086], [9074, 9076]]
}

variable "volume_names_node" {
  description = "ipfs node volume names - looping on them"
  type = list
  default = ["ipfs-node-1", "ipfs-node-2", "ipfs-node-3"]
}

variable "volume_names_cluster" {
  description = "ipfs node cluster names - looping on them"
  type = list
  default = ["ipfs-cluster-1", "ipfs-cluster-2", "ipfs-cluster-3"]
}

# variable "ipfs_volume_mounts" {
#   description = "Volume Mounts of the ipfs"
#   type        = list
#   default     = [
#     {
#       mount_path = "/data",
#       name = "ipfs-data",
#       sub_path =  "ipfs-pvc/ipfs-vol"
#     },
#     {
#       mount_path = "/staging",
#       name = "vol-ipfs-vol",
#       sub_path = "ipfs-pvc/ipfs-vol/staging"
#     }
#   ]
# }

variable "ipfs_volume_mounts" {
  description = "Volume Mounts of the ipfs"
  type        = list(any)
  default = []

}

variable "ipfs_volumes" {
  description = "Volume Mounts of the ipfs"
  type = list(object({
    name = string,
    persistent_volume_claim = object({
      claim_name = string
    }),
    secret = object({
      secret_name = string
    })
  }))
  default = []
}