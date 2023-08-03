# vanilla-azure-openshift-installer

## Run a vanilla Red Hat OpenShift 4 Cluster on Azure with `openshift-installer`

### Getting Started

1.
   Copy and modify environment file as needed
   ```bash
   cp env.example env.env

   # Edit if needed
   vim env.env
   ```
1. 
   ```bash
    git clone https://github.com/s-fairchild/vanilla-azure-openshift-installer.git
   ```
2. Review and complete all required steps [here](https://github.com/openshift/installer/blob/master/docs/dev/azure/azure_client_certs_auth.md)
   1. Also [Installing Azure Customizations for reference](https://docs.openshift.com/container-platform/4.13/installing/installing_azure/installing-azure-customizations.html)
3. Generate an ssh key pair
   1. This must be rsa or ecdsa when fips mode is enabled
4. Copy and modify as needed `env.example`
5. Modify `pre-install-config.yaml` as needed, it will be turned into the `install-config.yaml` file we need after substituting the variables
6. 
   ```bash
   ./run-openshift-install.sh
   ```