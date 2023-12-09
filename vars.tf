# Terraform variables for Terraform Cloud. This variables is required for Terraform Cloud.
variable "TF_ORGANIZATION" {
  description = "The name of the Terraform organization"
  type        = string
  default     = ""
}

variable "TF_WORKSPACE" {
  description = "The name of the Terraform workspace"
  type        = string
  default     = ""
} 

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