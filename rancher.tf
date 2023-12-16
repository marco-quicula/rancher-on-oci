data "external" "ks3_file" {
  depends_on = [data.cloudinit_config._[1]]
  program    = ["bash", "shell/get_file_content.sh", "ubuntu", oci_core_instance._[1].public_ip, "/home/ubuntu/k3s.yaml"]
}

resource "local_file" "kubeconfig" {
  depends_on = [data.external.ks3_file]
  content    = replace(base64decode(data.external.ks3_file.result.file_content), "127.0.0.1", oci_core_instance._[1].public_ip)
  filename   = "kubeconfig"
}

resource "null_resource" "install_kubectl" {
  provisioner "local-exec" {
    command = "sudo sh shell/install_kubectl.sh"
  }
}

resource "null_resource" "install_helm" {
  depends_on = [null_resource.install_kubectl]
  provisioner "local-exec" {
    command = "sudo sh shell/install_helm.sh"
  }
}

resource "null_resource" "install_rancher" {
  depends_on = [null_resource.install_kubectl, null_resource.install_helm, local_file.kubeconfig]
  provisioner "local-exec" {
    command = "sudo sh shell/install_rancher.sh ${local_file.kubeconfig.filename} ${var.cert-manager_version} ${var.rancher_version} ${var.sub_domain_rancher}-${local.nodes[1].node_number_to_string}.${var.domain_rancher} 1 ${random_string.bootstrapPassword.result}"
  }
}

resource "random_string" "bootstrapPassword" {
  length  = 16
  numeric = true
  lower   = true
  special = false
  upper   = false
}

locals {
  bootstrapPassword = random_string.bootstrapPassword.result
}

output "bootstrapPassword" {
  value = random_string.bootstrapPassword.result

}