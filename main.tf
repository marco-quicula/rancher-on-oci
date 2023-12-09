# Start the OCI provider with the credentials.
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

#OCI Compartment
resource "oci_identity_compartment" "compartment" {
    name        = var.compartment_name
    description = var.compartment_description
    compartment_id = var.tenancy_ocid
}