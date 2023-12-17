data "external" "ks3_control_plane_token" {
  depends_on = [data.cloudinit_config._[1]]
  program    = ["bash", "shell/get_file_content.sh", "${local_file.ssh_private_key.filename}", "ubuntu", oci_core_instance._[1].public_ip, "/var/lib/rancher/k3s/server/node-token"]
}

resource "null_resource" "install_k3s_workers" {
  depends_on = [null_resource.install_rancher_on_remotehost_local, null_resource.install_rancher_on_remotehost_remote]
  for_each   = { for key, value in local.nodes : key => value if value.role == "worker" }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local_file.ssh_private_key.content
    host        = oci_core_instance._[each.key].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${base64encode(file("shell/install_k3s_workers.sh"))}' | base64 --decode | sh -s ${local.nodes[1].private_ip_address} ${var.ks3_version} ${data.external.ks3_control_plane_token.result.file_content}"
    ]
  }
}
