data "cloudinit_config" "_" {
  for_each = local.nodes
  part {
    filename     = "cloud-config.cfg"
    content_type = "text/cloud-config"
    content      = <<-EOF
      hostname: ${each.value.node_name}
      EOF
  }

  # Remove REJECT rules from iptables
  part {
    filename     = "1-traffic.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/sh
      sed -i "s/-A INPUT -j REJECT --reject-with icmp-host-prohibited//" /etc/iptables/rules.v4 
      sed -i "s/-A FORWARD -j REJECT --reject-with icmp-host-prohibited//" /etc/iptables/rules.v4
      netfilter-persistent flush
      netfilter-persistent start
    EOF
  }

  # Install K3s
  part {
    filename     = "2-k3s.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/sh
      curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${var.ks3_version}" sh -s - server --tls-san "${var.sub_domain_rancher}-${each.value.node_number_to_string},${var.sub_domain_rancher}.${var.domain_rancher}" --cluster-init
      if [ -f /etc/rancher/k3s/k3s.yaml ]; then
        cp /etc/rancher/k3s/k3s.yaml /home/ubuntu || echo "Failed to copy k3s.yaml"
      else
        echo "/etc/rancher/k3s/k3s.yaml does not exist"
      fi
      chmod 777 /home/ubuntu/k3s.yaml
    EOF
  }
}
