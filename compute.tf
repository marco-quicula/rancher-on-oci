data "oci_identity_availability_domains" "_" {
  compartment_id = oci_identity_compartment._.id
}

data "oci_core_images" "_" {
  compartment_id           = oci_identity_compartment._.id
  shape                    = var.shape
  operating_system         = var.operating_system
  operating_system_version = var.operating_system_version
}

#Create a compute instance
resource "oci_core_instance" "_" {
  for_each            = local.nodes
  display_name        = each.value.node_name
  compartment_id      = oci_identity_compartment._.id
  availability_domain = data.oci_identity_availability_domains._.availability_domains[var.availability_domain].name
  shape               = var.shape
  shape_config {
    ocpus         = var.ocpus_per_node
    memory_in_gbs = var.memory_in_gbs_per_node
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images._.images[0].id
  }
  create_vnic_details {
    subnet_id        = oci_core_subnet._.id
    assign_public_ip = true
    private_ip       = each.value.private_ip_address
  }
  metadata = {
    ssh_authorized_keys = join("\n", local.authorized_keys)
    user_data           = data.cloudinit_config._[each.key].rendered
  }
  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = local_file.ssh_private_key.content
  }
  provisioner "remote-exec" {
    inline = [
      "tail -f /var/log/cloud-init-output.log &",
      "cloud-init status --wait >/dev/null",
    ]
  }
}
locals {
  truncated_subnet_cidr_block = join(".", slice(split(".", var.subnet_cidr_block), 0, 3))
  nodes = {
    for i in range(1, 1 + var.how_many_nodes) :
    i => {
      node_name             = format("%s%03d", var.prefix_node_name, i)
      node_number_to_string = format("%03d", i)
      private_ip_address    = format("%s.%d", local.truncated_subnet_cidr_block, var.subnet_cidr_block_initial_ip + i)
      role                  = i == 1 ? "controlplane" : "worker"
    }
  }
}
