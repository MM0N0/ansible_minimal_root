#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}

# build
# run build in "$SCRIPT_DIR/.." so .env is in the build context too
# and can be copied to the docker image
docker build -f "$SCRIPT_DIR/Dockerfile_ansible" --no-cache -t mm0n0/ansible_docker:v1 "$SCRIPT_DIR/.."
