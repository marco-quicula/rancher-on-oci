# OCI Credentials.
variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "private_key_path" {}

variable "region" {}

#OCI Compartment
variable "compartment_name" {}

variable "compartment_description" {}

# OCI Intance vars
variable "operating_system" {
  type    = string
  default = "Canonical Ubuntu"
}

variable "operating_system_version" {
  type    = string
  default = "22.04"
}
variable "shape" {
  type    = string
  default = "VM.Standard.E3.Flex"
}

variable "availability_domain" {
  type    = number
  default = 0
}

variable "how_many_nodes" {
  type    = number
  default = 1
}

variable "ocpus_per_node" {
  type    = number
  default = 1
}

variable "memory_in_gbs_per_node" {
  type    = number
  default = 8
}
variable "prefix_node_name" {
  type    = string
  default = "rancher-"
}
variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_cidr_block_initial_ip" {
  type    = number
  default = 20
}