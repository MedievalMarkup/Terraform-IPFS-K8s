# output "cluster_ip" {
#   value = kubernetes_service_v1.kb_ipfs_service.spec.0.cluster_ip
# }

# output "external_ip" {
#   value = tolist(kubernetes_service_v1.kb_ipfs_service.spec.0.external_ips)
# }

# output "port" {
#   value = kubernetes_service_v1.kb_ipfs_service.spec.0.port
# }