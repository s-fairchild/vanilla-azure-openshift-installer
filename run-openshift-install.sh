#!/bin/bash -x

. ./env.sh

set -o errexit \
        pipefail

log_level="${LOG_LEVEL:-info}"
install_config="${INSTALL_CONFIG:-./pre-install-config.yaml}"
install_dir="$(mktemp -d)"
echo "Installing into ${install_dir}..."

envsubst < "${install_config}" > "${install_dir}/install-config.yaml"

for g in $RESOURCEGROUP $RESOURCEGROUP_NETWORK $RESOURCEGROUP_NETWORK; do
    az group create -n "${g}" -l "${LOCATION}"
done

az network vnet create \
    -g "${RESOURCEGROUP_NETWORK}" \
    -n "${VNET}" \
    --address-prefixes "${VNET_PREFIXES}"

az network vnet subnet create -g "${RESOURCEGROUP_NETWORK}" --vnet-name "${VNET}" --name "${SUBNET}"  --address-prefixes "${SUBNET_PREFIXES}"

openshift-install create manifests --dir "${install_dir}" --log-level "${log_level}"

rm -rf "${install_dir}"
