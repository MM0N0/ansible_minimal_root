#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}

# build
docker build -f "$SCRIPT_DIR/Dockerfile_ansible" -t mm0n0/ansible_docker:v1 "$SCRIPT_DIR"
