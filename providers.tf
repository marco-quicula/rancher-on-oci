terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.22.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}