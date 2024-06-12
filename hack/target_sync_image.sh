#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

ORIGIN_IMAGE=$1
DOCKER_REGISTRY=$2

check_mirror() {
    local src_mirror_name=$(echo "$ORIGIN_IMAGE" | cut -d '/' -f 1)
    if ! grep -q "$src_mirror_name" mirrors.yaml; then
        echo "Error: Only these mirrors are supported."
        exit 1
    fi
}

main(){
    check_mirror
    echo "$DOCKER_PASSWORD" | skopeo login "$DOCKER_REGISTRY" -u "$DOCKER_USER" --password-stdin
    skopeo sync -s docker -d docker "$ORIGIN_IMAGE" "$DOCKER_REGISTRY"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to sync image $SRC_IMAGE."
        exit 1
    fi
}

main