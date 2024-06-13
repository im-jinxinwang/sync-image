#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

ORIGIN_IMAGE=${1:-}
DOCKER_REGISTRY=${2:-}

: "${DOCKER_USER:?Need to set DOCKER_USER}"
: "${DOCKER_PASSWORD:?Need to set DOCKER_PASSWORD}"

if [ -z "${SKOPEO_INSECURE+x}" ] || [ -z "$SKOPEO_INSECURE" ]; then
  SKOPEO_INSECURE=false
fi

check_mirror() {
    local src_mirror_name=$(echo "$ORIGIN_IMAGE" | cut -d '/' -f 1)
    if ! grep -q "$src_mirror_name" mirror_rules.yaml; then
        echo "Error: Only these mirrors are supported."
        exit 1
    fi
}

main(){
    check_mirror

    if [ "$SKOPEO_INSECURE" = "true" ]; then
        SRC_TLS_VERIFY="--src-tls-verify=false"
        DEST_TLS_VERIFY="--dest-tls-verify=false"
    else
        SRC_TLS_VERIFY="--src-tls-verify=true"
        DEST_TLS_VERIFY="--dest-tls-verify=true"
    fi

    skopeo sync "$SRC_TLS_VERIFY" "$DEST_TLS_VERIFY" -s docker -d docker --dest-username "$DOCKER_USER" --dest-password "$DOCKER_PASSWORD" "$ORIGIN_IMAGE" "$DOCKER_REGISTRY"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to sync image $ORIGIN_IMAGE."
        exit 1
    fi
}

main
