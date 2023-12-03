variable "namespace" {
  description = "Name of the Kubernetes namespace"
  type        = string
  default     = "cipher"
}

variable "name" {
  description = "Name of the api service"
  type        = string
  default     = ""
}

variable "command" {
  description = "Command to be executed"
  type        = list
  default     = []
}

variable "type" {
  description = "Exposed type of Service"
  type = string
  default = ""
}

variable "external_ips" {
  description = "List of external IPs"
  type = list
  default = []
}

variable "setup-port" {
  description = "Port number of the api service"
  type        = number
  default     = 7001
}



variable "config" {
  description = "config.json of api"
  type        = string
  default     = ""
}

variable "volume_mounts" {
  description = "Volume Mounts of the api "
  type        = list
  default     = []

}

variable "image_pull_secrets" {
  description = "Image Pull secret for images"
  type        = list
  default     = [{
      name = "secret"
  }]
}

variable "volumes" {
  description = "Volume Mounts of the api "
  type        = list(object({
      name = string,
      persistent_volume_claim = object({
          claim_name = string
      }),
      secret = object({
          secret_name = string
      })
  }))
  default     = []


}