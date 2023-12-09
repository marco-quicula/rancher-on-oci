# OCI Credentials.
variable "tenancy_ocid" {
  default = ""
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
  default = ""
}

variable "private_key_path" {
  default = ""
}

variable "region" {
  default = ""
}

#OCI Compartment
variable "compartment_name" {
    default = ""
}

variable "compartment_description" {
    default = ""
}