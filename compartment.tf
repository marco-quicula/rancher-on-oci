#OCI Compartment
resource "oci_identity_compartment" "compartment" {
  name           = var.compartment_name
  description    = var.compartment_description
}