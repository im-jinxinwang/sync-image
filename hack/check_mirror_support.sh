#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

ISSUE_DATA=$(gh issue list -l "porter" --limit 1 --json number,title)
ISSUE_TITLE=$(echo $ISSUE_DATA| jq -r '.[].title')
ISSUE_NUMBER=$(echo $ISSUE_DATA| jq -r '.[].number')
SRC_IMAGE=$(echo "$ISSUE_TITLE" | sed 's/\[[^]]*\]//g' | tr -d ' ')
src_mirror_name=$(echo "$ISSUE_TITLE" | cut -d '/' -f 1)

check_mirror() {
    if ! grep -q "$src_mirror_name" mirrors.yaml; then
        echo "Error: Only these mirrors are supported."
        exit 1
    fi
}

sync_image() {
    local docker_password="${DOCKER_PASSWORD:-}"
    if [ -z "$docker_password" ]; then
        echo "Error: Docker password not provided."
        exit 1
    fi
    
    echo "$docker_password" | skopeo login "$DOCKER_REGISTRY" -u "$DOCKER_USER" --password-stdin
    skopeo sync -s docker -d docker "$SRC_IMAGE" "$DOCKER_REGISTRY/$DOCKER_NAMESPACE"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to sync image $SRC_IMAGE."
        exit 1
    fi
    local NEW_IMAGE=$(sed "s#$src_mirror_name#$DOCKER_REGISTRY/$DOCKER_NAMESPACE#g" <<<"${SRC_IMAGE}")
    gh issue comment $ISSUE_NUMBER -b "镜像 ${SRC_IMAGE} 同步完成<br>请使用 ${NEW_IMAGE} 下载"
    gh issue close $ISSUE_NUMBER --reason "completed"
}

check_mirror
sync_image
