# OCI Credential values for local usage. 
# You can set environment variables 
# using the example setenv.sh file, either to avoid directly exposing 
# your credentials or to obtain them in the way that you find most appropriate. 
# Nevertheless, if you wish, you can uncomment the lines and fill in the values 
# directly in this file.

# You can get the values of the variables at the following path: 
# Identity -> My profile, in the API keys section.
#tenancy_ocid     = "your_tenancy_ocid"
#user_ocid        = "your_user_ocid"
#fingerprint      = "your_fingerprint"
#region           = "your_region"
#private_key_path = "your_private_key_path"

#OCI Compartment
compartment_name                                            = "mycompartment"
compartment_description                                     = "Compartment to install the resources."
install_kubernetes_tools_on_terraform_execution_environment = true
rancher_installation_mode                                   = "local"