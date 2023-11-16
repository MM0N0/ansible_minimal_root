#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}

# build
# run build in "$SCRIPT_DIR/.." so .env is in the build context too
# and the repository can be copied to the docker image
docker build -f "$SCRIPT_DIR/Dockerfile" -t mm0n0/dev_docker_ansible_minimal_root:v1 "$SCRIPT_DIR/.."
docker build -f "$SCRIPT_DIR/Dockerfile_test_host" -t mm0n0/test_host_ansible_minimal_root:v1 "$SCRIPT_DIR"
