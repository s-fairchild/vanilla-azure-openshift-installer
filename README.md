# vanilla-azure-openshift-installer

## Run a vanilla Red Hat OpenShift 4 Cluster on Azure with `openshift-installer`

### Getting Started

1.
   Copy and modify environment file as needed
   ```bash
   cp env.example env.env

   # Edit if needed
   vim env.env
   . env.env
   ```
1. Clone this repository
   ```bash
    git clone https://github.com/s-fairchild/vanilla-azure-openshift-installer.git
   ```
1. Create service principal
   ```bash
   az ad sp create-for-rbac -n ${CLUSTER} \
      --create-cert \
      --role Contributor \
      --create-cert \
      --scopes "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${RESOURCEGROUP_NETWORK}" \
      "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${RESOURCEGROUP}"
   ```
1. Copy the certificate generated into `secrets/`
2. Follow [these instructions](https://github.com/openshift/installer/blob/master/docs/dev/azure/azure_client_certs_auth.md#creating-a-certificate) to create `cert.pfx` using the certificate copied in the previous step
   ```bash
   cd secrets/
   openssl pkcs12 -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -export -macalg sha1 -inkey cert_and_key.pem -in cert_and_key.pem -export -out cert.pfx
   cd ..
   ```
3. Create role assignment
      ```bash
      az role assignment create \
         --assignee <appID> \
         --role "User Access Administrator"
         --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${RESOURCEGROUP_NETWORK}"

      az role assignment create \
         --assignee <appID> \
         --role "User Access Administrator"
         --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${RESOURCEGROUP_CLUSTER}"

      az role assignment create \
         --assignee <appID> \
         --role "User Access Administrator"
         --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${RESOURCEGROUP}"
      ```
4. Update `~/.azure/osServicePrincipal.json` with the following
   1. clientId
   2. clientCertificate
   3. clientCertificatePassword
   4. appId
   5. displayName
   6. tenant
   7. tenantId
   8. subscriptionId
5. Review and complete all required steps [here](https://github.com/openshift/installer/blob/master/docs/dev/azure/azure_client_certs_auth.md)
   1. Also [Installing Azure Customizations for reference](https://docs.openshift.com/container-platform/4.13/installing/installing_azure/installing-azure-customizations.html)
6. Generate an ssh key pair
   1. This must be rsa or ecdsa when fips mode is enabled
7. Copy and modify as needed `env.example`
8. Modify `pre-install-config.yaml` as needed, it will be turned into the `install-config.yaml` file we need after substituting the variables
9.  
   ```bash
   ./run-openshift-install.sh
   ```