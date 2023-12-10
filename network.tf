#Include VNC
resource "oci_core_virtual_network" "_" {
  cidr_block     = var.vnc_cidr_block
  compartment_id = oci_identity_compartment._.id
  display_name   = format("%s%s", "vcn-", oci_identity_compartment._.name)
  dns_label      = substr(oci_identity_compartment._.name, 0, 15)
}

#Include Internet Gateway
resource "oci_core_internet_gateway" "_" {
  display_name   = format("%s%s", "igw-", oci_identity_compartment._.name)
  compartment_id = oci_identity_compartment._.id
  vcn_id         = oci_core_virtual_network._.id
}

#Include Default Resource Route Table
resource "oci_core_default_route_table" "_" {
  manage_default_resource_id = oci_core_virtual_network._.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway._.id
  }
}

#Include Default Security List
resource "oci_core_default_security_list" "_" {
  manage_default_resource_id = oci_core_virtual_network._.default_security_list_id
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

#Include subnet
resource "oci_core_subnet" "_" {
  cidr_block        = var.subnet_cidr_block
  compartment_id    = oci_identity_compartment._.id
  vcn_id            = oci_core_virtual_network._.id
  display_name      = "publicsubnet"
  dns_label         = "publicsubnet"
  security_list_ids = [oci_core_virtual_network._.default_security_list_id]
  route_table_id    = oci_core_virtual_network._.default_route_table_id
  dhcp_options_id   = oci_core_virtual_network._.default_dhcp_options_id
}
