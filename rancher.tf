data "external" "ks3_file" {
  depends_on = [ data.cloudinit_config._[1] ]
  program = ["bash", "get_file_content.sh", "ubuntu", oci_core_instance._[1].public_ip ,"/ubuntu/home/k3s.yaml" ]
}

output "ks3_file" {
  value = "${data.external.ks3_file.result}"
}
