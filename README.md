<div align="justify">

# rancher-on-oci
Terraform scripts to provision an OCI cluster, install k3s, and configure Rancher. A complete solution for container infrastructure.

<img src="images/rancher.png" >
<img src="images/k3s.png">
<img src="images/oci.png">

## About the Project
Uncover the magic of container orchestration with this repository! Here you'll find Terraform scripts that, like a maestro, orchestrate the creation of a robust cluster on Oracle Cloud Infrastructure (OCI), install the lightweight and powerful k3s, and finally set up Rancher, the market-leading container management platform. A complete solution to take your container infrastructure to the next level!

## Purpose
This project exists primarily for learning purposes and is not intended to configure an environment with all the characteristics of a production environment, although it serves as a good base example for the same.

## Prerequisites
- <a href="https://developer.hashicorp.com/terraform/install?product_intent=terraform">Terraform</a>
- <a href="https://www.oracle.com/br/cloud/sign-in.html">OCI account with administrative privileges</a>

## How to use
1. Clone this repository
2. Configure your OCI credential variables as local variables using the example `setenv.sh` file that exists in the project, or directly modify the `terraform.tfvars` file, as instructed in this file.
3. Run `terraform init` to initialize Terraform
4. Run `terraform apply` to create the infrastructure

## Extra instructions to set up Github Action pipeline
1. First, follow the instructions requested by GitHub.
2. Ensure that the OCI credentials variables are properly commented in the `terraform.tfvars` file.
cd r3. Include the following SECRETS in your REPOSITORY.
    - `TF_API_TOKEN` : Terraform user token
    - `TF_VAR_private_key_value` : In this case, you will include the file content in the secret value. OCI Credential
4. Include the following SECRETS in your ENVIRONMENT.
    - `OCI_NODE_PRIVATEKEY` : Access node with ssh
    - `OCI_NODE_PUBLICKEY` : Access node with ssh
5. Include the following VARIABLES in your REPOSITORY.
    - `TF_VAR_tenancy_ocid`
    - `TF_VAR_user_ocid`
    - `TF_VAR_fingerprint`
    - `TF_VAR_region`
6. Include the following VARIABLES in your ENVIRONMENT.
    - `TF_ORGANIZATION` : Terraform Clod Organization
    - `TF_WORKSPACE` : Terraform Clod Workspace
    - `TF_VAR_COMPARTMENT` : OCI Compartment

## Important Considerations

### 1. Local Terraform Execution

When running Terraform locally, ensure that the `sudo` command does not prompt for a password. This can be configured in your environment or may have been set by running a previous command using `sudo`.

### 2. Kubernetes Tools

If you already have `kubectl` and `helm` installed in your local environment, you can simply change the value of the `install_kubernetes_tools_on_terraform_execution_environment` variable to `false`.

### 3. Rancher Installation

If you wish to execute the Rancher installation directly on the created instance, change the value of the `rancher_installation_mode` variable to `remote`.

Please follow these considerations when setting up and running the project.

## Configuring Rancher
Once the infrastructure is ready, you can configure Rancher. Here are the basic steps:

1. Access the Rancher IP address in your browser
2. Follow the on-screen instructions to configure Rancher

## Contributing
If you found a bug or would like to add a new feature, feel free to open an issue or a pull request.

## Contact
<ul>
  <img src="images/marco.png" >
  <li>Email: <a href="mailto:marco.quicula@quicula.com.br">marco.quicula@quicula.com.br</a></li>
  <li>Website: <a href="http://www.quicula.com.br">www.quicula.com.br</a></li>
  <li>LinkedIn: <a href="https://www.linkedin.com/in/marco-quicula/">https://www.linkedin.com/in/marco-quicula/</a></li>
</ul>
</div>
