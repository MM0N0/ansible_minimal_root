#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}
source "$SCRIPT_DIR/.env"

# publish
docker push "mm0n0/dev_docker_$PROJECT_NAME:v1"
docker push "mm0n0/test_host_$PROJECT_NAME:v1"
