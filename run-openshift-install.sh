#!/bin/bash -x

set -o errexit \
    -o pipefail

main() {
    . ./env.sh

    if [[ $1 != "--skip-preinstall" ]]; then
        pre_install
    fi

    log_level="${LOG_LEVEL:-info}"
    install_config="${INSTALL_CONFIG:-./pre-install-config.yaml}"
    install_dir="$(mktemp -d)"
    echo "Installing into ${install_dir}..."

    envsubst < "${install_config}" > "${install_dir}/install-config.yaml"

    openshift-install create manifests --dir "${install_dir}" --log-level "${log_level}"
}

pre_install() {
    echo "Creating required resources"
    for g in "$RESOURCEGROUP" "$RESOURCEGROUP_NETWORK" "$RESOURCEGROUP_COMPUTE" "$RESOURCEGROUP_CLUSTER"; do
        az group create -n "${g}" -l "${LOCATION}"
    done

    az network vnet create \
        -g "${RESOURCEGROUP_NETWORK}" \
        -n "${VNET}" \
        --address-prefixes "${VNET_PREFIXES}"

    az network vnet subnet create \
        -g "${RESOURCEGROUP_NETWORK}" \
        --vnet-name "${VNET}" \
        --name "${WORKER_SUBNET}" \
        --address-prefixes "${WORKER_SUBNET_PREFIXES}"

    az network vnet subnet create \
        -g "${RESOURCEGROUP_NETWORK}" \
        --vnet-name "${VNET}" \
        --name "${MASTER_SUBNET}" \
        --address-prefixes "${MASTER_SUBNET_PREFIXES}"


}

create_sp() {
    az ad sp create-for-rbac \
        --role contributor \
        --name "${USER}-cluster" \
        --scopes "/subscriptions/${AZURE_SUBSCRIPTION_ID}"
    
    az ad sp credential reset \
        --id b0e43187-7970-446c-af68-6a82f96d0707 \
        --cert "@secrets/cert.pem"
}

main "${@}"
