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
- Terraform v0.12+
- OCI account with administrative privileges

## How to use
1. Clone this repository
2. Configure your OCI credentials in the `vars.tf` file
3. Run `terraform init` to initialize Terraform
4. Run `terraform apply` to create the infrastructure

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