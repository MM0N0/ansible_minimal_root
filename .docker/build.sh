#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}

# build
# run build in "$SCRIPT_DIR/.." so .env is in the build context too
# and can be copied to the docker image
docker build -f "$SCRIPT_DIR/Dockerfile_ansible" -t mm0n0/ansible_docker:v1 "$SCRIPT_DIR/.."
docker build -f "$SCRIPT_DIR/Dockerfile_ubuntu" -t mm0n0/ubuntu_ansible_test_host:v1 "$SCRIPT_DIR"
