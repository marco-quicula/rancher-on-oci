data "external" "ks3_file" {
  count      = var.rancher_installation_mode == "local" ? 1 : 0
  depends_on = [data.cloudinit_config._[1]]
  program    = ["bash", "shell/get_file_content.sh", "${local_file.ssh_private_key.filename}", "ubuntu", oci_core_instance._[1].public_ip, "/home/ubuntu/k3s.yaml"]
}

resource "local_file" "kubeconfig" {
  count           = var.rancher_installation_mode == "local" ? 1 : 0
  content         = replace(base64decode(data.external.ks3_file[count.index].result.file_content), "127.0.0.1", oci_core_instance._[1].public_ip)
  filename        = "kubeconfig"
  file_permission = "0600"
}

resource "null_resource" "install_kubectl_locally" {
  count = var.install_kubernetes_tools_on_terraform_execution_environment && var.rancher_installation_mode == "local" ? 1 : 0
  provisioner "local-exec" {
    command = "sudo sh shell/install_kubectl.sh"
  }
}

resource "null_resource" "install_helm_locally" {
  count      = var.install_kubernetes_tools_on_terraform_execution_environment && var.rancher_installation_mode == "local" ? 1 : 0
  depends_on = [null_resource.install_kubectl_locally]
  provisioner "local-exec" {
    command = "sudo sh shell/install_helm.sh"
  }
}

resource "null_resource" "install_kubectl_on_remotehost" {
  count      = var.rancher_installation_mode == "remote" ? 1 : 0
  depends_on = [oci_core_instance._[1]]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local_file.ssh_private_key.content
    host        = oci_core_instance._[1].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${base64encode(file("shell/install_kubectl.sh"))}' | base64 --decode | sh -s"
    ]
  }
}

resource "null_resource" "install_helm_on_remotehost" {
  count      = var.rancher_installation_mode == "remote" ? 1 : 0
  depends_on = [null_resource.install_kubectl_on_remotehost, oci_core_instance._[1]]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local_file.ssh_private_key.content
    host        = oci_core_instance._[1].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${base64encode(file("shell/install_helm.sh"))}' | base64 --decode | sh -s"
    ]
  }
}

resource "null_resource" "remote_installation_of_rancher" {
  count      = var.rancher_installation_mode == "local" ? 1 : 0
  depends_on = [null_resource.install_kubectl_on_remotehost, null_resource.install_helm_on_remotehost, oci_core_instance._[1]]
  provisioner "local-exec" {
    command = "sudo sh shell/install_rancher.sh ${local_file.kubeconfig[count.index].filename} ${var.cert-manager_version} ${var.rancher_version} ${var.sub_domain_rancher}-${local.nodes[1].node_number_to_string}.${var.domain_rancher} 1 ${random_string.bootstrapPassword.result}"
  }
}

resource "null_resource" "install_rancher_on_remotehost" {
  count      = var.rancher_installation_mode == "execute" ? 1 : 0
  depends_on = [oci_core_instance._[1]]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local_file.ssh_private_key.content
    host        = oci_core_instance._[1].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${base64encode(file("shell/install_rancher.sh"))}' | base64 --decode | sh -s k3s ${var.cert-manager_version} ${var.rancher_version} ${var.sub_domain_rancher}-${local.nodes[1].node_number_to_string}.${var.domain_rancher} 1 ${random_string.bootstrapPassword.result}"
    ]
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

output "rancher_host" {
  value = "${var.sub_domain_rancher}-${local.nodes[1].node_number_to_string}.${var.domain_rancher}"
}

output "rancher_public_ip" {
  value = oci_core_instance._[1].public_ip
}