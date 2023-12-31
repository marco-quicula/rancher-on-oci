data "cloudinit_config" "_" {
  for_each = local.nodes
  part {
    filename     = "cloud-config.cfg"
    content_type = "text/cloud-config"
    content      = <<-EOF
      hostname: ${each.value.node_name}
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
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
  # Install K3s controlplane node
  dynamic "part" {
    for_each = each.value.role == "controlplane" ? [1] : []
    content {
      filename     = "2-k3s.sh"
      content_type = "text/x-shellscript"
      content      = <<-EOF
        #!/bin/sh
        echo "Getting public IP address..."
        PUBLIC_IP_ADDRESS=$(curl https://icanhazip.com/)
        echo "."
        echo "Installing KS3 ${each.value.role} node with version=${var.ks3_version} and IP=$PUBLIC_IP_ADDRESS..."
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${var.ks3_version}" sh -s - server --tls-san "$PUBLIC_IP_ADDRESS,${var.sub_domain_rancher}-${each.value.node_number_to_string}.${var.domain_rancher},${var.sub_domain_rancher}.${var.domain_rancher}" --cluster-init
        KUBE_API_SERVER=$PUBLIC_IP_ADDRESS:6443
        while ! curl --insecure https://$KUBE_API_SERVER; do
          echo "."
          echo "K3S API server ($KUBE_API_SERVER) not responding."
          echo "Waiting 10 seconds before we try again."
          sleep 10
        done
        echo "."
        echo "K3S API server controleplane ($KUBE_API_SERVER) appears to be up."
        echo "."
        echo "Copying k3s file to home on controlplane node."
        if [ -f /etc/rancher/k3s/k3s.yaml ]; then
          cp /etc/rancher/k3s/k3s.yaml /home/ubuntu || echo "Failed to copy k3s.yaml"
          chmod 777 /home/ubuntu/k3s.yaml
        else
          echo "/etc/rancher/k3s/k3s.yaml does not exist"
        fi
      EOF
    }
  }
}
