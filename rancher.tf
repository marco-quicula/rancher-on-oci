data "external" "ks3_file" {
  depends_on = [ data.cloudinit_config._[1] ]
  program = ["bash", "get_file_content.sh", "ubuntu", oci_core_instance._[1].public_ip ,"/home/ubuntu/k3s.yaml" ]
}

resource "local_file" "kubeconfig" {
  depends_on = [ data.external.ks3_file ]
  content    = replace(base64decode(data.external.ks3_file.result.file_content),"127.0.0.1",oci_core_instance._[1].public_ip)
  filename   = "kubeconfig"
}

resource "kubernetes_namespace" "cattle-system" {
  depends_on = [ local_file.kubeconfig ]
  metadata {
    name = "cattle-system"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  depends_on = [ local_file.kubeconfig ]
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [ kubernetes_namespace.cert-manager ]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "1.13.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "rancher" {
  depends_on = [ helm_release.cert_manager ]
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/latest"
  chart      = "rancher"
  namespace  = "cattle-system"

  set {
    name  = "hostname"
    value = "${var.sub_domain_rancher}-${local.nodes[1].node_number_to_string}.${var.domain_rancher}"
  }
  
  set {
    name  = "hostname"
    value = "${var.sub_domain_rancher}.${var.domain_rancher}"
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "bootstrapPassword"
    value = "Praiseesw8868812"
  }
}

resource "random_string" "bootstrapPassword" {
  length  = 16
  numeric = true
  lower   = true
  special = true
  upper   = true
}

locals {
  bootstrapPassword = random_string.bootstrapPassword.result
}

output "bootstrapPassword" {
  value = random_string.bootstrapPassword.result
  
}