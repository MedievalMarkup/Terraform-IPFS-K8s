module "ipfs_node" {
  source  =   "./modules/ipfs/ipfs-node"
  count = length(var.volume_names_node)
  namespace    = var.namespace 
  name         = var.volume_names_node[count.index]
  ports         = [
    {
      port = element(var.ports_of_node[count.index], 0)
      protocol = "TCP"
      name = "${var.volume_names_node[count.index]}-swarm-port"
    },
    {
      port = element(var.ports_of_node[count.index], 1)
      protocol = "TCP"
      name = "${var.volume_names_node[count.index]}-api-port",
    }
  ]
  type         = var.type 
  volume_mounts = concat(var.ipfs_volume_mounts, [
    {
      mount_path = "/data/${var.volume_names_node[count.index]}",
      name       = "${var.volume_names_node[count.index]}-volume",
      sub_path   = "eserv/appConfig/ipfs",
    }
  ]) 
  volumes = concat(var.ipfs_volumes, [
    {
      name = "${var.ipfs_name}-volume",
      persistent_volume_claim = {
        claim_name = "pvcforipfs"
      },
      host_path = null,
      secret    = null,
    }
  ])
}

module "ipfs_cluster" {
  source  =   "./modules/ipfs/ipfs-cluster"
  count = length(var.volume_names_cluster)
  namespace    = var.namespace 
  name         = var.volume_names_cluster[count.index]
  ports         = [
    {
      port = element(var.ports_of_cluster[count.index], 0)
      protocol = "TCP"
      name = "${var.volume_names_cluster[count.index]}-api-port"
    },
    {
      port = element(var.ports_of_cluster[count.index], 1)
      protocol = "TCP"
      name = "${var.volume_names_cluster[count.index]}-ctl-port",
    }
  ]
  type         = var.type 
  volume_mounts = concat(var.ipfs_volume_mounts, [
    {
      mount_path = "/data/${var.volume_names_cluster[count.index]}",
      name       = "${var.volume_names_cluster[count.index]}-volume",
      sub_path   = "eserv/appConfig/ipfs",
    }
  ]) 
  volumes = concat(var.ipfs_volumes, [
    {
      name = "${var.ipfs_name}-volume",
      persistent_volume_claim = {
        claim_name = "pvcforipfs"
      },
      host_path = null,
      secret    = null,
    }
  ])
}

resource "null_resource" "delete broadcast"{
  count = length(var.volume_names_node)
  provisioner "local-exec" {
    command = "kubectl -n ${var.cipher_namespace} exec -it $(kubectl -n ${var.cipher_namespace} get pods --selector=app=${var.volume_names_node[count.index]} -o jsonpath='{.items[0].metadata.name}') -- ipfs bootstrap rm all"
  }
  environment = {
    CAD = "/"
  }
}

 module "ipfs-setup" {
  source = "./modules/ipfs/ipfs-setup"
  image_pull_secrets = concat(var.image_pull_secrets, [{
    name = var.image_secret_name
  }])
  namespace = var.cipher_namespace
  name      = var.setup_name
  volume_mounts = concat(var.setup_volume_mounts, [{
    mount_path = "/opt/app-root/temp",
    name       = "${var.setup_name}-volume",
    sub_path   = "appConfig/ipfs-setup"
  }])
  volumes = concat(var.setup_volumes, [{
    name = "${var.setup_name}-volume",
    persistent_volume_claim = {
      claim_name = "${var.cipher_pvc_name}"
    },
    host_path = null,
    secret    = null
  }])

  command = [
    "node",
    "app",
    "${var.setup_script}",
    "--clusterNames=${var.volume_names_cluster[0]},${var.volume_names_cluster[1]},${var.volume_names_cluster[2]}",
    "--nodeIPS=$",
    "--multiAddressPorts=",
    "--nodeMultiAddressPorts=",
    "--ipfsProxy_multiAddressPorts=",
    "--httpAddressPorts=http=",
  ]
  depends_on = [
    module.ipfs_cluster,
    module.ipfs_node,
  ]
}







