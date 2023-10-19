#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}

# build
docker build -f "$SCRIPT_DIR/Dockerfile_ubuntu" -t mm0n0/ubuntu_ansible_test_host:v1 "$SCRIPT_DIR"
