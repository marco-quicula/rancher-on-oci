data "external" "ks3_file" {
  depends_on = [ data.cloudinit_config._[1] ]
  program = ["bash", "get_file_content.sh", "k3s", oci_core_instance._[1].public_ip ,"/etc/rancher/k3s/k3s.yaml" ]
}

output "ks3_file" {
  value = "${data.external.ks3_file.result}"
}
